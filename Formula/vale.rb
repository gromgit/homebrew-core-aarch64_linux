class Vale < Formula
  desc "Syntax-aware linter for prose"
  homepage "https://errata-ai.github.io/vale/"
  url "https://github.com/errata-ai/vale/archive/v2.6.2.tar.gz"
  sha256 "cb53adc58cb2c72b996074683f622b21b7fdbc865e81a873ff0e7d4b08fd74be"
  license "MIT"

  bottle do
    cellar :any_skip_relocation
    sha256 "ecf8becc3f6df1c0f69fd9de6d53079956ba77469b95d83a04d72c34d91fac33" => :big_sur
    sha256 "e18864ae458114704ee2aabb2aed2c891a777a70858bd5470aca29ec5aa77734" => :catalina
    sha256 "8de8ba5db5f06b0eb266ff5609f1115ad149c8b7d7f83a83ddde9bb7e9101d44" => :mojave
  end

  depends_on "go" => :build

  def install
    ldflags = "-X main.version=#{version} -s -w"
    system "go", "build", *std_go_args, "-ldflags=#{ldflags}"
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
