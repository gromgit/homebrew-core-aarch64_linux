class Vale < Formula
  desc "Syntax-aware linter for prose"
  homepage "https://errata-ai.github.io/vale/"
  url "https://github.com/errata-ai/vale/archive/v2.3.4.tar.gz"
  sha256 "ed98607aa089c1802a6848d512606ddbe7b534448e056f78f0a5021001cdd0e4"
  license "MIT"

  bottle do
    cellar :any_skip_relocation
    sha256 "91745cb4751f5a4640fb138edbf267075161417edeb3e673e8a058120192a440" => :catalina
    sha256 "6656479cb57fd4fb0a8277b8d2e56be1e76090b3dd107a62c7f80c8bd57c475a" => :mojave
    sha256 "6d86dc159ba127a149049f18a11dc928810c7e844822f51b06e0673869d271d5" => :high_sierra
  end

  depends_on "go" => :build

  def install
    flags = "-X main.version=#{version} -s -w"
    system "go", "build", "-ldflags=#{flags}", "-o", "#{bin}/#{name}"
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
    assert_match("✖ 0 errors, 1 warning and 0 suggestions in 1 file.", output)
  end
end
