class Vale < Formula
  desc "Syntax-aware linter for prose"
  homepage "https://errata-ai.github.io/vale/"
  url "https://github.com/errata-ai/vale/archive/v2.7.1.tar.gz"
  sha256 "5cbda74f229a582666c14ada85365b8f45b2f9c3d5a4bbe1068872291c2ec242"
  license "MIT"

  bottle do
    cellar :any_skip_relocation
    sha256 "37e430e4afb894f3c4d40fab91f5a81334b03805b0168f23ca9df92e6ee0323e" => :big_sur
    sha256 "9297ad3ab8521bd5fadbf2c76c7e02904d5e053312d862fa02d87da39d118fd0" => :arm64_big_sur
    sha256 "4f063e24cc9f0035f426f7a8038a6249edd792ab36ac89fec40bf004d6b03f1a" => :catalina
    sha256 "44e713c5fe32c5ad8b02da82ff4c34453003b5c4d022555928ab62a18acebf59" => :mojave
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
