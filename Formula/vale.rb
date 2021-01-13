class Vale < Formula
  desc "Syntax-aware linter for prose"
  homepage "https://errata-ai.github.io/vale/"
  url "https://github.com/errata-ai/vale/archive/v2.8.0.tar.gz"
  sha256 "b0ab637508aedbc11e5cd7fe225d45f9fd44e821720233dbbbbdc39f8b104250"
  license "MIT"

  bottle do
    cellar :any_skip_relocation
    sha256 "8de72e99a7bd2fd8d156c8e26fbac388af484a26100a71518983d3041458abd8" => :big_sur
    sha256 "c32347bf6026b0d8e95b4e0ce972eacea5624cabf23e15a9c1c5ca8a75ac9d83" => :arm64_big_sur
    sha256 "7a69622772a8df80ff575afea2b9c7752cf01c5cc9a0e5f880f1b6eb6b138335" => :catalina
    sha256 "131161266422f69c7aea9acd32053243862d5db06906f70acd260f162d69431a" => :mojave
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
