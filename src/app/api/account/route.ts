import { NextRequest, NextResponse } from "next/server";
import { getMysqlPool } from "@/lib/mysql";
import { encodeSession, LOCAL_SESSION_COOKIE, getServerSessionUser } from "@/lib/local-auth";

async function loadProfile(userId: string) {
  const pool = getMysqlPool();
  const [rows] = await pool.query(
    `SELECT id, full_name, email, role, department_id, phone, address, position_title, must_change_password
     FROM profiles
     WHERE id = ?
     LIMIT 1`,
    [userId]
  );
  return (rows as any[])[0] ?? null;
}

function refreshSessionCookie(response: NextResponse, profile: any) {
  response.cookies.set(
    LOCAL_SESSION_COOKIE,
    encodeSession({
      id: String(profile.id),
      email: String(profile.email),
      role: profile.role,
      full_name: profile.full_name ?? null,
      must_change_password: Boolean(profile.must_change_password),
    }),
    {
      httpOnly: true,
      sameSite: "lax",
      secure: process.env.NODE_ENV === "production",
      path: "/",
      maxAge: 60 * 60 * 24 * 7,
    }
  );
}

export async function GET() {
  const user = await getServerSessionUser();
  if (!user) {
    return NextResponse.json({ error: "Unauthorized" }, { status: 401 });
  }

  const profile = await loadProfile(user.id);
  if (!profile) {
    return NextResponse.json({ error: "Profile not found" }, { status: 404 });
  }

  return NextResponse.json({ profile });
}

export async function PATCH(req: NextRequest) {
  const user = await getServerSessionUser();
  if (!user) {
    return NextResponse.json({ error: "Unauthorized" }, { status: 401 });
  }

  const body = await req.json();
  const fullName = typeof body.full_name === "string" ? body.full_name.trim() : null;
  const email = typeof body.email === "string" ? body.email.trim() : null;
  const phone = typeof body.phone === "string" ? body.phone.trim() : null;
  const address = typeof body.address === "string" ? body.address.trim() : null;
  const positionTitle = typeof body.position_title === "string" ? body.position_title.trim() : null;

  const pool = getMysqlPool();
  const [existing] = await pool.query(
    `SELECT id FROM profiles WHERE email = ? AND id <> ? LIMIT 1`,
    [email || user.email, user.id]
  );
  if ((existing as any[]).length > 0) {
    return NextResponse.json({ error: "Email already exists." }, { status: 409 });
  }

  await pool.query(
    `UPDATE profiles
     SET full_name = ?, email = ?, phone = ?, address = ?, position_title = ?
     WHERE id = ?`,
    [fullName || null, email || user.email, phone || null, address || null, positionTitle || null, user.id]
  );

  const profile = await loadProfile(user.id);
  const response = NextResponse.json({ ok: true, profile });
  if (profile) refreshSessionCookie(response, profile);
  return response;
}

export async function PUT(req: NextRequest) {
  const user = await getServerSessionUser();
  if (!user) {
    return NextResponse.json({ error: "Unauthorized" }, { status: 401 });
  }

  const body = await req.json();
  const currentPassword = typeof body.current_password === "string" ? body.current_password : "";
  const newPassword = typeof body.new_password === "string" ? body.new_password : "";
  const confirmPassword = typeof body.confirm_password === "string" ? body.confirm_password : "";

  if (!currentPassword || !newPassword || !confirmPassword) {
    return NextResponse.json({ error: "All password fields are required." }, { status: 400 });
  }
  if (newPassword !== confirmPassword) {
    return NextResponse.json({ error: "Passwords do not match." }, { status: 400 });
  }

  const pool = getMysqlPool();
  const [rows] = await pool.query(
    `SELECT id FROM profiles WHERE id = ? AND password = ? LIMIT 1`,
    [user.id, currentPassword]
  );
  if ((rows as any[]).length === 0) {
    return NextResponse.json({ error: "Current password is incorrect." }, { status: 400 });
  }

  await pool.query(
    `UPDATE profiles SET password = ?, must_change_password = 0 WHERE id = ?`,
    [newPassword, user.id]
  );

  const profile = await loadProfile(user.id);
  const response = NextResponse.json({ ok: true, profile });
  if (profile) refreshSessionCookie(response, profile);
  return response;
}