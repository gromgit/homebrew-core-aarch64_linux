class Vale < Formula
  desc "Syntax-aware linter for prose"
  homepage "https://docs.errata.ai/"
  url "https://github.com/errata-ai/vale/archive/v2.16.0.tar.gz"
  sha256 "f478825c5a44ee6f29bef9dc64b3effefcbecd61607c0aff197ca0c8c4be65cf"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "13f32abdfb13445876985ab6528f9e8539c0972b792767e68c96633a5421fce6"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "3c689dd59a859e96eb507352149c593eb9ed7682d745cba73aaba8dc839203d3"
    sha256 cellar: :any_skip_relocation, monterey:       "cb7238a52316105cfc79dff8c247f78a92ae44349ae507132e8aede1e6b481ec"
    sha256 cellar: :any_skip_relocation, big_sur:        "9098e0ca12cb0c319830f83ee00ca5244d97742000f1248c26680edc22219b88"
    sha256 cellar: :any_skip_relocation, catalina:       "62352f038cde4f2fd7f8edc6776a06e83db1e83b1ddc0862d6d944e827983b94"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "ccaa7d3659503c754a7f1a51e7579017d3b50bc78c5278f0b54b7921b5d59891"
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
