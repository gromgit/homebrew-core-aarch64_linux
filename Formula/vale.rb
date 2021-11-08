class Vale < Formula
  desc "Syntax-aware linter for prose"
  homepage "https://errata-ai.github.io/vale/"
  url "https://github.com/errata-ai/vale/archive/v2.12.1.tar.gz"
  sha256 "0dda66e3f2b14f4be2e4a188d2acbfe4f0087b2086bcb59b3abb4dc87fa3633c"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "9f2e51dd4e730b93fa67cb5c41181066b5e80e9b0a091cd3e967bf9769085525"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "b294ccc70f4692150b16b379eedbe24dec75c827b636c28917dbe1172d50006d"
    sha256 cellar: :any_skip_relocation, monterey:       "0bf6f6082a490efb66738cae70797e96fb292218902876d72ef1e66ad0326bb5"
    sha256 cellar: :any_skip_relocation, big_sur:        "984ab0a3c2f0385a4156fd9aa82b03c6d27da5e17e4e894edd5dce31959ea34e"
    sha256 cellar: :any_skip_relocation, catalina:       "6d2ad905fd4af011f41f71f205f326a307daeaaba64c25606605af1eda7ecfdd"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "6791836ec4938ec610f9506a7d57a656ed42eed23d2095951fa4c891250464c2"
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
