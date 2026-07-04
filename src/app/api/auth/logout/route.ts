import { NextResponse } from "next/server";
import { LOCAL_SESSION_COOKIE } from "@/lib/local-auth";

export async function GET(request: Request) {
  const response = NextResponse.redirect(new URL("/auth/login", request.url));
  response.cookies.set(LOCAL_SESSION_COOKIE, "", {
    path: "/",
    maxAge: 0,
  });
  return response;
}

export async function POST() {
  const response = NextResponse.json({ ok: true });
  response.cookies.set(LOCAL_SESSION_COOKIE, "", {
    path: "/",
    maxAge: 0,
  });
  return response;
}

