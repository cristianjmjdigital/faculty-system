"use client";

import { useRouter } from "next/navigation";
import { useState } from "react";
import { getSupabaseBrowserClient } from "@/lib/supabase-browser";

type SignOutButtonProps = {
  className?: string;
  children?: React.ReactNode;
};

export default function SignOutButton({ className, children }: SignOutButtonProps) {
  const router = useRouter();
  const [isLoading, setIsLoading] = useState(false);

  const handleSignOut = async () => {
    if (isLoading) return;
    setIsLoading(true);

    try {
      const supabase = getSupabaseBrowserClient();
      await supabase.auth.signOut();
    } finally {
      router.push("/auth/login");
      router.refresh();
      setIsLoading(false);
    }
  };

  return (
    <button type="button" className={className} onClick={handleSignOut} disabled={isLoading}>
      {children ?? "Sign out"}
    </button>
  );
}
