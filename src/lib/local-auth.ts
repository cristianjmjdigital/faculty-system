import { cookies } from "next/headers";

export type UserRole = "admin" | "faculty" | "student" | "evaluator" | "program_head";

export type LocalSessionUser = {
  id: string;
  email: string;
  role: UserRole;
  full_name: string | null;
  must_change_password?: boolean;
};

export const LOCAL_SESSION_COOKIE = "local_session";

export function encodeSession(user: LocalSessionUser): string {
  return Buffer.from(JSON.stringify(user), "utf8").toString("base64url");
}

export function decodeSession(raw?: string | null): LocalSessionUser | null {
  if (!raw) return null;
  try {
    const parsed = JSON.parse(Buffer.from(raw, "base64url").toString("utf8")) as LocalSessionUser;
    if (!parsed?.id || !parsed?.email || !parsed?.role) return null;
    return parsed;
  } catch {
    return null;
  }
}

export async function getServerSessionUser(): Promise<LocalSessionUser | null> {
  const cookieStore = await cookies();
  const token = cookieStore.get(LOCAL_SESSION_COOKIE)?.value;
  return decodeSession(token);
}

export function roleDefaultPath(role: LocalSessionUser["role"]): string {
  if (role === "admin") return "/admin";
  if (role === "program_head") return "/program-head";
  if (role === "faculty") return "/faculty";
  if (role === "evaluator") return "/evaluator";
  return "/student";
}

export function roleLoginPath(role: UserRole): string {
  if (role === "admin") return "/auth/login/admin";
  if (role === "program_head") return "/auth/login/faculty";
  if (role === "faculty") return "/auth/login/faculty";
  if (role === "evaluator") return "/auth/login/faculty";
  return "/auth/login/student";
}

