class Vale < Formula
  desc "Syntax-aware linter for prose"
  homepage "https://errata-ai.github.io/vale/"
  url "https://github.com/errata-ai/vale/archive/v2.3.1.tar.gz"
  sha256 "edc2aac40ae67b325cbcea887dcb8d4fa16993e16da319b23f96d7108093c366"
  license "MIT"

  bottle do
    cellar :any_skip_relocation
    sha256 "d1ca90d460bd47d58e8d67994deecc5373a93f9776c5d6fd5c1d223dc61f18d8" => :catalina
    sha256 "187b43bfeb41e424959fc9fca5f73c27e8345f13c72171daa33edf5394484ce6" => :mojave
    sha256 "b8a1656c5ca94356e12ef0cffda11f5e76dbc448b400b04fdb234b39902e8915" => :high_sierra
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
