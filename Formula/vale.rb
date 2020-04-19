class Vale < Formula
  desc "Syntax-aware linter for prose"
  homepage "https://errata-ai.github.io/vale/"
  url "https://github.com/errata-ai/vale/archive/v2.1.1.tar.gz"
  sha256 "3f3ab62ed3927f35e5539dffd6c982c8f7992d1100dc2e4c4c4ee411b748dff9"

  bottle do
    cellar :any_skip_relocation
    sha256 "4d04d13cfa5d578298d5a219812cecdcfc5bd974048ccff91f2760a421aa26dd" => :catalina
    sha256 "1c702149245c654729684fbdfad60057aa8a514ca5461faf20629b82f9382d6c" => :mojave
    sha256 "a5a08ee8a4eaa782a8c68c09e195005f2c3b573effcb9fb4f207736134cbc932" => :high_sierra
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
