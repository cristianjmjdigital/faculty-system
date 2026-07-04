import { NextRequest, NextResponse } from "next/server";
import { executeDbOperation, type DbOperation } from "@/lib/offline-db";
import { getServerSessionUser } from "@/lib/local-auth";

export async function POST(req: NextRequest) {
  const session = await getServerSessionUser();
  if (!session) {
    return NextResponse.json({ data: null, error: { message: "Unauthorized" } }, { status: 401 });
  }

  const operation = (await req.json()) as DbOperation;
  const result = await executeDbOperation(operation);
  return NextResponse.json(result, { status: result.error ? 400 : 200 });
}

