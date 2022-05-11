class Vale < Formula
  desc "Syntax-aware linter for prose"
  homepage "https://docs.errata.ai/"
  url "https://github.com/errata-ai/vale/archive/v2.16.2.tar.gz"
  sha256 "bf7d548f41e6f007e6585f08ae6c37df1af457012cbe27ef6975b4f4dce9e3c6"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "67cb2d483c2b2e48d3ad5313b99aed7691f74ebeb207a492148c61726cd2d755"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "a90214ccea863c442555962e1b3b2b7b5030dec7bc0b69fc6276d87356869e9f"
    sha256 cellar: :any_skip_relocation, monterey:       "425c90f6dd12e24001346644720d1c3ca6269e40d414a9fee57ef7a4d534610e"
    sha256 cellar: :any_skip_relocation, big_sur:        "49858fafcb3c9013fb8c50bccb94f93a586664014a7e8ce2412826dd08852617"
    sha256 cellar: :any_skip_relocation, catalina:       "16ab541ef53a03ffeeda3e949b2becb29add5ab3a651397b3646ef510e7b77e3"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "e650c839e65130c50837ea71df8cb9b644ebdf4b71f754637905e71063b6eedb"
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
