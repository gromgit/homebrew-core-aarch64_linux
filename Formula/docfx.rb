class Docfx < Formula
  desc "Tools for building and publishing API documentation for .NET projects"
  homepage "https://dotnet.github.io/docfx/"
  url "https://github.com/dotnet/docfx/releases/download/v2.58.2/docfx.zip"
  sha256 "1ca42ba47da7897eb3c7c38fd6a45283884b26a40e4af5c2d61b0f6b5a67dc1e"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "2073fd8b2e32d42fc754f534610432a0175dded8b86cba1f5e7fdb3886b46b79"
  end

  depends_on arch: :x86_64
  depends_on "mono"

  def install
    libexec.install Dir["*"]

    (bin/"docfx").write <<~EOS
      #!/bin/bash
      mono #{libexec}/docfx.exe "$@"
    EOS
  end

  test do
    system bin/"docfx", "init", "-q"
    assert_predicate testpath/"docfx_project/docfx.json", :exist?,
                     "Failed to generate project"
  end
end
