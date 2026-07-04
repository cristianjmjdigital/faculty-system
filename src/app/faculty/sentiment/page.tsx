import { loadFacultyData } from "@/lib/faculty-data";

export const dynamic = "force-dynamic";

const STOP_WORDS = new Set([
  "the",
  "and",
  "for",
  "that",
  "this",
  "with",
  "was",
  "are",
  "were",
  "have",
  "has",
  "had",
  "from",
  "they",
  "them",
  "their",
  "about",
  "very",
  "really",
  "just",
  "but",
  "you",
  "your",
  "our",
  "can",
  "could",
  "would",
  "more",
  "some",
  "into",
  "than",
  "when",
  "what",
  "who",
  "how",
  "been",
  "being",
  "because",
  "faculty",
  "teacher",
  "class",
  "student",
]);

function getOverallTone(positive: number, neutral: number, negative: number, total: number) {
  if (total === 0) {
    return { label: "No sentiment data yet", color: "text-slate-500" };
  }

  const sentimentIndex = (positive - negative) / total;
  if (sentimentIndex >= 0.35) {
    return { label: "Strongly positive overall tone", color: "text-emerald-600" };
  }
  if (sentimentIndex >= 0.1) {
    return { label: "Mostly positive tone", color: "text-emerald-500" };
  }
  if (sentimentIndex <= -0.35) {
    return { label: "Strong negative signal", color: "text-rose-600" };
  }
  if (sentimentIndex <= -0.1) {
    return { label: "Mixed tone leaning negative", color: "text-rose-500" };
  }
  if (neutral >= Math.max(positive, negative)) {
    return { label: "Mostly neutral tone", color: "text-slate-500" };
  }
  return { label: "Mixed tone", color: "text-amber-600" };
}

function getConfidenceLabel(total: number) {
  if (total >= 10) return "High confidence";
  if (total >= 5) return "Medium confidence";
  if (total >= 3) return "Early pattern";
  return "Too few submissions";
}

function extractTopThemes(comments: string[]): string[] {
  const counts = new Map<string, number>();

  comments.forEach((comment) => {
    const tokens = comment
      .toLowerCase()
      .replace(/[^a-z\s]/g, " ")
      .split(/\s+/)
      .filter((word) => word.length >= 4 && !STOP_WORDS.has(word));

    const uniqueTokens = new Set(tokens);
    uniqueTokens.forEach((token) => {
      counts.set(token, (counts.get(token) ?? 0) + 1);
    });
  });

  return Array.from(counts.entries())
    .sort((a, b) => b[1] - a[1])
    .slice(0, 4)
    .map(([word]) => word);
}

export default async function SentimentPage() {
  const { sentiments } = await loadFacultyData();

  const total = sentiments.length;
  const positive = sentiments.filter((s) => s.sentiment === "positive");
  const neutral = sentiments.filter((s) => s.sentiment === "neutral");
  const negative = sentiments.filter((s) => s.sentiment === "negative");

  const pct = (n: number) => (total > 0 ? Math.round((n / total) * 100) : 0);

  const withComments = sentiments.filter((s) => s.comments);
  const commentTexts = withComments.map((s) => s.comments?.trim() ?? "").filter(Boolean);
  const topThemes = extractTopThemes(commentTexts);
  const tone = getOverallTone(positive.length, neutral.length, negative.length, total);
  const confidence = getConfidenceLabel(total);
  const netScore = total > 0 ? Math.round(((positive.length - negative.length) / total) * 100) : 0;

  return (
    <div className="section-shell space-y-8 fade-in">
      <header className="space-y-1">
        <div className="badge">Sentiment</div>
        <h1 className="mt-2 text-2xl font-bold text-ink">Sentiment Report</h1>
        <p className="text-slate-600 text-sm">
          Student sentiment feedback across all evaluation periods.
        </p>
      </header>

      {total === 0 ? (
        <div className="stat-card p-8 text-center">
          <p className="text-slate-400">No student sentiments submitted yet.</p>
        </div>
      ) : (
        <>
          <div className="card glass">
            <div className="card-header">
              <h2 className="text-lg font-semibold text-ink">Sentiment Summary</h2>
              <span className="text-xs text-slate-500">{confidence}</span>
            </div>
            <div className="card-body space-y-3">
              <p className="text-sm text-slate-700">
                Overall signal: <span className={`font-semibold ${tone.color}`}>{tone.label}</span>
              </p>
              <p className="text-sm text-slate-700">
                Net positivity score: <span className="font-semibold text-slate-900">{netScore}%</span>
                <span className="ml-2 text-xs text-slate-500">(positive% minus negative%)</span>
              </p>
              {total >= 3 ? (
                <p className="text-sm text-slate-600">
                  Summary based on {total} submissions: students are giving a {tone.label.toLowerCase()}.
                  {negative.length > positive.length
                    ? " Prioritize follow-up on recurring concerns from comments."
                    : " Continue reinforcing the practices students are responding well to."}
                </p>
              ) : (
                <p className="text-sm text-amber-700 bg-amber-50 border border-amber-200 rounded-lg px-3 py-2">
                  This summary is preliminary. At least 3 sentiments are recommended for a stable trend.
                </p>
              )}

              {topThemes.length > 0 && (
                <div>
                  <p className="text-xs font-medium uppercase tracking-wider text-slate-500 mb-2">Common Comment Themes</p>
                  <div className="flex flex-wrap gap-2">
                    {topThemes.map((theme) => (
                      <span
                        key={theme}
                        className="rounded-full bg-slate-100 px-3 py-1 text-xs font-medium text-slate-700"
                      >
                        {theme}
                      </span>
                    ))}
                  </div>
                </div>
              )}
            </div>
          </div>

          {/* Distribution cards */}
          <div className="grid gap-4 sm:grid-cols-3">
            <div className="stat-card p-5 text-center">
              <p className="text-xs font-medium uppercase tracking-wider text-emerald-400">Positive</p>
              <p className="mt-1 text-4xl font-extrabold text-slate-900">{positive.length}</p>
              <p className="text-sm text-slate-500">{pct(positive.length)}%</p>
            </div>
            <div className="stat-card p-5 text-center">
              <p className="text-xs font-medium uppercase tracking-wider text-slate-400">Neutral</p>
              <p className="mt-1 text-4xl font-extrabold text-slate-900">{neutral.length}</p>
              <p className="text-sm text-slate-500">{pct(neutral.length)}%</p>
            </div>
            <div className="stat-card p-5 text-center">
              <p className="text-xs font-medium uppercase tracking-wider text-rose-400">Negative</p>
              <p className="mt-1 text-4xl font-extrabold text-slate-900">{negative.length}</p>
              <p className="text-sm text-slate-500">{pct(negative.length)}%</p>
            </div>
          </div>

          {/* Visual bar */}
          <div className="stat-card p-5">
            <p className="mb-3 text-xs font-medium uppercase tracking-wider text-slate-400">Distribution</p>
            <div className="flex h-6 w-full overflow-hidden rounded-full">
              {positive.length > 0 && (
                <div
                  className="bg-emerald-500 transition-all duration-700"
                  style={{ width: `${pct(positive.length)}%` }}
                  title={`Positive: ${pct(positive.length)}%`}
                />
              )}
              {neutral.length > 0 && (
                <div
                  className="bg-slate-400 transition-all duration-700"
                  style={{ width: `${pct(neutral.length)}%` }}
                  title={`Neutral: ${pct(neutral.length)}%`}
                />
              )}
              {negative.length > 0 && (
                <div
                  className="bg-rose-500 transition-all duration-700"
                  style={{ width: `${pct(negative.length)}%` }}
                  title={`Negative: ${pct(negative.length)}%`}
                />
              )}
            </div>
            <div className="mt-2 flex justify-between text-xs text-slate-500">
              <span>{pct(positive.length)}% Positive</span>
              <span>{pct(neutral.length)}% Neutral</span>
              <span>{pct(negative.length)}% Negative</span>
            </div>
          </div>

          {/* Comments list */}
          {withComments.length > 0 && (
            <div className="card glass">
              <div className="card-header">
                <h2 className="text-lg font-semibold text-ink">Student Comments</h2>
                <span className="text-xs text-slate-400">{withComments.length} comment{withComments.length !== 1 ? "s" : ""}</span>
              </div>
              <div className="card-body space-y-2 max-h-[500px] overflow-y-auto">
                {withComments.map((s) => {
                  const colorMap: Record<string, string> = {
                    positive: "border-l-emerald-500 bg-emerald-500/10",
                    neutral: "border-l-slate-400 bg-slate-500/10",
                    negative: "border-l-rose-500 bg-rose-500/10",
                  };
                  const labelColor: Record<string, string> = {
                    positive: "text-emerald-400",
                    neutral: "text-slate-400",
                    negative: "text-rose-400",
                  };
                  return (
                    <div
                      key={s.id}
                      className={`rounded-lg border-l-4 p-3 ${colorMap[s.sentiment] ?? ""}`}
                    >
                      <div className="flex items-center justify-between mb-1">
                        <span className={`text-xs font-semibold capitalize ${labelColor[s.sentiment] ?? ""}`}>
                          {s.sentiment}
                        </span>
                        <span className="text-xs text-slate-500">
                          {new Date(s.created_at).toLocaleDateString()}
                        </span>
                      </div>
                      <p className="text-sm text-slate-700">{s.comments}</p>
                    </div>
                  );
                })}
              </div>
            </div>
          )}
        </>
      )}
    </div>
  );
}
