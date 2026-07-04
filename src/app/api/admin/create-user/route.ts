import { NextRequest, NextResponse } from "next/server";
import { randomUUID } from "crypto";
import { getMysqlPool } from "@/lib/mysql";
import { getServerSessionUser } from "@/lib/local-auth";

const validRoles = new Set(["admin", "faculty", "student", "evaluator", "program_head"]);

export async function POST(req: NextRequest) {
  try {
    const actor = await getServerSessionUser();
    if (!actor || actor.role !== "admin") {
      return NextResponse.json({ error: "Unauthorized" }, { status: 401 });
    }

    const { full_name, email, password, role, department_id } = await req.json();

    if (!email || !password) {
      return NextResponse.json({ error: "Email and password are required." }, { status: 400 });
    }

    const targetRole = validRoles.has(role) ? role : "faculty";
    const pool = getMysqlPool();

    const [existing] = await pool.query("SELECT id FROM profiles WHERE email = ? LIMIT 1", [email]);
    if ((existing as any[]).length > 0) {
      return NextResponse.json({ error: "Email already exists." }, { status: 409 });
    }

    const userId = randomUUID();

    await pool.query(
      `INSERT INTO profiles (id, full_name, email, password, role, department_id, must_change_password)
       VALUES (?, ?, ?, ?, ?, ?, ?)`,
      [userId, full_name || null, email, password, targetRole, department_id || null, 1]
    );

    return NextResponse.json({ ok: true, userId });
  } catch (error: any) {
    console.error("Create local user error:", error);
    return NextResponse.json({ error: error?.message || "Unable to create user." }, { status: 500 });
  }
}

