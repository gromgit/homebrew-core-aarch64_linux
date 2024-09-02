class Unarj < Formula
  desc "ARJ file archiver"
  homepage "http://www.arjsoftware.com/files.htm"
  url "https://src.fedoraproject.org/repo/pkgs/unarj/unarj-2.65.tar.gz/c6fe45db1741f97155c7def322aa74aa/unarj-2.65.tar.gz"
  sha256 "d7dcc325160af6eb2956f5cb53a002edb2d833e4bb17846669f92ba0ce3f0264"

  bottle do
    root_url "https://github.com/gromgit/homebrew-core-aarch64_linux/releases/download/unarj"
    sha256 cellar: :any_skip_relocation, aarch64_linux: "c60a7c7c6cb834ce4d13b46a0ff27224c575044e2bf95bb19bc5007e12a5d39a"
  end

  resource "testfile" do
    url "https://s3.amazonaws.com/ARJ/ARJ286.EXE"
    sha256 "e7823fe46fd971fe57e34eef3105fa365ded1cc4cc8295ca3240500f95841c1f"
  end

  def install
    system "make"
    bin.mkdir
    system "make", "install", "INSTALLDIR=#{bin}"
  end

  test do
    # Ensure that you can extract arj.exe from a sample self-extracting file
    resource("testfile").stage do
      system "#{bin}/unarj", "e", "ARJ286.EXE"
      assert_predicate Pathname.pwd/"arj.exe", :exist?
    end
  end
end
