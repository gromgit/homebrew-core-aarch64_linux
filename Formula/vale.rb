class Vale < Formula
  desc "Syntax-aware linter for prose"
  homepage "https://errata-ai.github.io/vale/"
  url "https://github.com/errata-ai/vale/archive/v2.4.2.tar.gz"
  sha256 "27f9046bda890f8fa64d8af17095b97a8c0e0db1fbec792f90c2ba61b8a550da"
  license "MIT"

  bottle do
    cellar :any_skip_relocation
    sha256 "0d8764e447d458f3c62d7f778b82660af11eb8ff6185cc3e07083321127a6d01" => :catalina
    sha256 "6e0c92d27e17f5631aa375f4655d0c61f4a9369f50efb83eedbf64d7d1ce6571" => :mojave
    sha256 "68d7a21d87e17be0cc4bd7dcf2426de22ea6459635c6488f52017caa5e6cf9f2" => :high_sierra
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
