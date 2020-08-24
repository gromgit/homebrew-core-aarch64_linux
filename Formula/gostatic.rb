class Gostatic < Formula
  desc "Fast static site generator"
  homepage "https://github.com/piranha/gostatic"
  url "https://github.com/piranha/gostatic/archive/2.23.tar.gz"
  sha256 "dc7ceb31e00c55a98b5b39767d591a49ab826c0f87de79efcfc3ac5269813c93"
  license "ISC"
  head "https://github.com/piranha/gostatic.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "35119b8faabc1535ee3cbd07784c28946dd80e5ab70d7106e8d3a263cfd85a91" => :catalina
    sha256 "7f7e7eb137e2476d58b583ae157b80d9f38c4087a5a60790b8b54202b064dc4a" => :mojave
    sha256 "cba0f92cb6d4f2dda5cbcce639756320ecd17cf3a422fdbb8deac54c73fb9767" => :high_sierra
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args
  end

  test do
    (testpath/"config").write <<~EOS
      TEMPLATES = site.tmpl
      SOURCE = src
      OUTPUT = out
      TITLE = Hello from Homebrew

      index.md:
      \tconfig
      \text .html
      \tmarkdown
      \ttemplate site
    EOS

    (testpath/"site.tmpl").write <<~EOS
      {{ define "site" }}
      <html><head><title>{{ .Title }}</title></head><body>{{ .Content }}</body></html>
      {{ end }}
    EOS

    (testpath/"src/index.md").write "Hello world!"

    system bin/"gostatic", testpath/"config"
    assert_predicate testpath/"out/index.html", :exist?
  end
end
