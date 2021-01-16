class Vale < Formula
  desc "Syntax-aware linter for prose"
  homepage "https://errata-ai.github.io/vale/"
  url "https://github.com/errata-ai/vale/archive/v2.8.1.tar.gz"
  sha256 "2d8575fc2ad64feba22b2f3befe94494d4019a80b5a0c0cf652d48858be60147"
  license "MIT"

  bottle do
    cellar :any_skip_relocation
    sha256 "590b15b39285fd259261da8c17ecb6830ceb6bfa8655fdb9aa2ef96965026f39" => :big_sur
    sha256 "1ff06ef916c211f9acfa78632545992740837bf5dcbf0678024530669a04118b" => :arm64_big_sur
    sha256 "a692616e7343bcd13bb44057335373fb2b4072ec6af617a4f11c1df237c22b4e" => :catalina
    sha256 "9c0daea18d09fec6bffda138e52a73acbe25de5805a2515dea53f869ab5f6973" => :mojave
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
