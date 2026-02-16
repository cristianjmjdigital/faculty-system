import type { Config } from "tailwindcss";

const config: Config = {
  content: [
    "./src/pages/**/*.{js,ts,jsx,tsx,mdx}",
    "./src/components/**/*.{js,ts,jsx,tsx,mdx}",
    "./src/app/**/*.{js,ts,jsx,tsx,mdx}"
  ],
  theme: {
    extend: {
      colors: {
        midnight: "#0f172a",
        sand: "#f8fafc",
        accent: "#22c55e",
        ink: "#0b1120"
      }
    }
  },
  plugins: [],
};

export default config;
