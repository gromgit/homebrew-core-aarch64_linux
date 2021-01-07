class Vale < Formula
  desc "Syntax-aware linter for prose"
  homepage "https://errata-ai.github.io/vale/"
  url "https://github.com/errata-ai/vale/archive/v2.7.0.tar.gz"
  sha256 "c6ffbd86275141ccf909b4d19b10a84932de6ace180a1c6206ded6ad71168b4e"
  license "MIT"

  bottle do
    cellar :any_skip_relocation
    sha256 "1986dd9f269658d6ad06e4106ede968b1fa6c2a63e092e20a1d9ee36fe446488" => :big_sur
    sha256 "8bc3ad611839c17d26ef7b7944a8031d771a97f79aab5095c694a09144b5ad8b" => :arm64_big_sur
    sha256 "37e466ff727faf8326863f16548c1cd10ca2fc12232836dbf24e99751e2d67f2" => :catalina
    sha256 "5930b7dc78e4a216979083212dafd8b9ff18a5b327a7bb6962c40b30a6da2b08" => :mojave
  end

  depends_on "go" => :build

  def install
    ldflags = "-X main.version=#{version} -s -w"
    system "go", "build", *std_go_args, "-ldflags=#{ldflags}", "./cmd/vale"
  end

  test do
    mkdir_p "styles/demo"
    (testpath/"styles/demo/HeadingStartsWithCapital.yml").write <<~EOS
      extends: capitalization
      message: "'%s' should be in title case"
      level: warning
      scope: heading.h1
      match: $title
    EOS

    (testpath/"vale.ini").write <<~EOS
      StylesPath = styles
      [*.md]
      BasedOnStyles = demo
    EOS

    (testpath/"document.md").write("# heading is not capitalized")

    output = shell_output("#{bin}/vale --config=#{testpath}/vale.ini #{testpath}/document.md 2>&1")
    assert_match(/✖ .*0 errors.*, .*1 warning.* and .*0 suggestions.* in 1 file\./, output)
  end
end
