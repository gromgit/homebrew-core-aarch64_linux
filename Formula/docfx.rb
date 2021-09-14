class Docfx < Formula
  desc "Tools for building and publishing API documentation for .NET projects"
  homepage "https://dotnet.github.io/docfx/"
  url "https://github.com/dotnet/docfx/releases/download/v2.58.4/docfx.zip"
  sha256 "5dc9e63ce084ad16a9f19f0e18a80194db3244f9d9af4ceab699c2729b46378d"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "74c7ebd3ce6a10764903c0ca18d99e93614c611ba53e6e7fdb91744bef19e303"
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
