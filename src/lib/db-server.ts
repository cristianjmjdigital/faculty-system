import { executeDbOperation, type DbOperation } from "@/lib/offline-db";

type DbResult = { data: any; error: { message: string } | null; count?: number };

class ServerQueryBuilder implements PromiseLike<DbResult> {
  private operation: DbOperation;

  constructor(table: string) {
    this.operation = { table, action: "select", filters: [], inFilters: [], order: [] };
  }

  select(columns: string, options?: { count?: "exact"; head?: boolean }) {
    if (this.operation.action === "select") {
      this.operation.action = "select";
    }
    this.operation.columns = columns;
    this.operation.count = options?.count;
    this.operation.head = options?.head;
    return this;
  }

  eq(column: string, value: any) {
    this.operation.filters = [...(this.operation.filters || []), { column, value }];
    return this;
  }

  in(column: string, values: any[]) {
    this.operation.inFilters = [...(this.operation.inFilters || []), { column, values }];
    return this;
  }

  order(column: string, options?: { ascending?: boolean; foreignTable?: string }) {
    this.operation.order = [...(this.operation.order || []), { column, ...(options || {}) }];
    return this;
  }

  limit(n: number) {
    this.operation.limit = n;
    return this;
  }

  insert(values: any) {
    this.operation.action = "insert";
    this.operation.values = values;
    return this;
  }

  update(values: any) {
    this.operation.action = "update";
    this.operation.values = values;
    return this;
  }

  delete() {
    this.operation.action = "delete";
    return this;
  }

  maybeSingle() {
    this.operation.maybeSingle = true;
    return this.execute();
  }

  single() {
    this.operation.single = true;
    return this.execute();
  }

  async execute(): Promise<DbResult> {
    return executeDbOperation(this.operation);
  }

  then<TResult1 = DbResult, TResult2 = never>(
    onfulfilled?: ((value: DbResult) => TResult1 | PromiseLike<TResult1>) | null,
    onrejected?: ((reason: any) => TResult2 | PromiseLike<TResult2>) | null
  ): Promise<TResult1 | TResult2> {
    return this.execute().then(onfulfilled ?? undefined, onrejected ?? undefined);
  }
}

export function getDbServerClient() {
  return {
    from(table: string) {
      return new ServerQueryBuilder(table);
    },
  };
}

