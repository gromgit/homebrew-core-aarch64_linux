class Vale < Formula
  desc "Syntax-aware linter for prose"
  homepage "https://errata-ai.github.io/vale/"
  url "https://github.com/errata-ai/vale/archive/v2.4.2.tar.gz"
  sha256 "27f9046bda890f8fa64d8af17095b97a8c0e0db1fbec792f90c2ba61b8a550da"
  license "MIT"

  bottle do
    cellar :any_skip_relocation
    sha256 "e4910b86643d487872d6cd78b226fae1adffe53db3010e0ce9f72ab7015f830f" => :catalina
    sha256 "5f2e3fbb3aecb2e3786555f7cdef938731c1f70c0ae2dbc1f4ed50f04d1c0b7b" => :mojave
    sha256 "a764666a8cc95602ecfbd843bc55c30361a2c688bfdaf65c70a40fe7767966ed" => :high_sierra
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
