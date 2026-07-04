import { NextResponse } from "next/server";
import { getServerSessionUser } from "@/lib/local-auth";
import { getMysqlPool } from "@/lib/mysql";

export async function GET() {
  const user = await getServerSessionUser();
  if (!user) {
    return NextResponse.json({ user: null }, { status: 401 });
  }

  try {
    const pool = getMysqlPool();
    const [rows] = await pool.query(
      `SELECT id, email, role, full_name, must_change_password
       FROM profiles
       WHERE id = ?
       LIMIT 1`,
      [user.id]
    );

    const profile = (rows as any[])[0];
    if (!profile) {
      return NextResponse.json({ user: null }, { status: 401 });
    }

    return NextResponse.json({
      user: {
        id: String(profile.id),
        email: String(profile.email),
        role: profile.role,
        full_name: profile.full_name ?? null,
        must_change_password: Boolean(profile.must_change_password),
      },
    });
  } catch {
    return NextResponse.json({ user });
  }
}

