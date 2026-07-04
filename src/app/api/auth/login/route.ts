import { NextRequest, NextResponse } from "next/server";
import { getMysqlPool } from "@/lib/mysql";
import { encodeSession, LOCAL_SESSION_COOKIE, roleDefaultPath, type LocalSessionUser, type UserRole } from "@/lib/local-auth";

const validRoles = new Set<UserRole>(["admin", "faculty", "student", "evaluator", "program_head"]);

export async function POST(req: NextRequest) {
  try {
    const { email, password, next, expectedRole } = await req.json();

    if (!email || !password) {
      return NextResponse.json({ error: "Email and password are required." }, { status: 400 });
    }

    const pool = getMysqlPool();
    const [rows] = await pool.query(
      `SELECT id, email, role, full_name, must_change_password
       FROM profiles
       WHERE email = ? AND password = ?
       LIMIT 1`,
      [email, password]
    );

    const user = (rows as any[])[0];
    if (!user) {
      return NextResponse.json({ error: "Invalid credentials." }, { status: 401 });
    }

    const sessionUser: LocalSessionUser = {
      id: String(user.id),
      email: String(user.email),
      role: user.role as LocalSessionUser["role"],
      full_name: user.full_name ?? null,
      must_change_password: Boolean(user.must_change_password),
    };

    const requestedRole: UserRole | null = validRoles.has(expectedRole) ? expectedRole : null;
    if (requestedRole && sessionUser.role !== requestedRole) {
      return NextResponse.json({ error: `This account is not allowed on the ${requestedRole} login.` }, { status: 403 });
    }

    const requestedNext = typeof next === "string" && next.startsWith("/") ? next : roleDefaultPath(sessionUser.role);
    const safeNext = sessionUser.must_change_password ? "/auth/change-password" : requestedNext;
    const response = NextResponse.json({
      ok: true,
      next: safeNext,
      role: sessionUser.role,
      mustChangePassword: Boolean(sessionUser.must_change_password),
    });

    response.cookies.set(LOCAL_SESSION_COOKIE, encodeSession(sessionUser), {
      httpOnly: true,
      sameSite: "lax",
      secure: process.env.NODE_ENV === "production",
      path: "/",
      maxAge: 60 * 60 * 24 * 7,
    });

    return response;
  } catch (error) {
    console.error("Local login error:", error);
    return NextResponse.json({ error: "Unable to sign in right now." }, { status: 500 });
  }
}

