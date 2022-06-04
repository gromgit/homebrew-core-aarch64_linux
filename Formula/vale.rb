class Vale < Formula
  desc "Syntax-aware linter for prose"
  homepage "https://docs.errata.ai/"
  url "https://github.com/errata-ai/vale/archive/v2.16.1.tar.gz"
  sha256 "f28f7365a3779919333c56d530f49ce2bbdebd4c05b5dcecd8b9ed77dcea126e"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "9ca5b46965fc83d57a042ce97de34844a7a5713a70351f3a86a43dce1baac745"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "69aeba3d79d02c49ee10a6669ee05df36b9fed30f0a85f243a2544bb9f2d66ef"
    sha256 cellar: :any_skip_relocation, monterey:       "146405ee818169338237daaba4fa9e279e3a7a9d61e8088402f7e06777afcb9a"
    sha256 cellar: :any_skip_relocation, big_sur:        "dfc62368ffde2333a9360bfdea54c5f5318eba377514aa45da8b426a094de1c3"
    sha256 cellar: :any_skip_relocation, catalina:       "983f5c4537b581b98ed5b36ba1ad8f400760b67a79508c939ddae856c463ea7f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "a0d4bdb89504d6834ca529967a35dc0bfee46ac1b20ba93ecaec07fcdba4e5e2"
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
