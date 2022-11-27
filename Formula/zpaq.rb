class Zpaq < Formula
  desc "Incremental, journaling command-line archiver"
  homepage "http://mattmahoney.net/dc/zpaq.html"
  url "http://mattmahoney.net/dc/zpaq715.zip"
  version "7.15"
  sha256 "e85ec2529eb0ba22ceaeabd461e55357ef099b80f61c14f377b429ea3d49d418"
  license "Unlicense"
  revision 1
  head "https://github.com/zpaq/zpaq.git", branch: "master"

  bottle do
    root_url "https://github.com/gromgit/homebrew-core-aarch64_linux/releases/download/zpaq"
    sha256 cellar: :any_skip_relocation, aarch64_linux: "928eaef43de1cce61ba4af160ac4d9a27e68605f5cf528b23cab0a6201c9b22b"
  end

  resource "test" do
    url "http://mattmahoney.net/dc/calgarytest2.zpaq"
    sha256 "b110688939477bbe62263faff1ce488872c68c0352aa8e55779346f1bd1ed07e"
  end

  def install
    # When building on non-Intel this is supposed to be manually uncommented
    # from the Makefile!  (It's also missing "-D" though)
    inreplace "Makefile", "# CPPFLAGS+=NOJIT", "CPPFLAGS+=-DNOJIT" unless Hardware::CPU.intel?
    system "make"
    system "make", "check"
    system "make", "install", "PREFIX=#{prefix}"
  end

  test do
    testpath.install resource("test")
    assert_match "all OK", shell_output("#{bin}/zpaq x calgarytest2.zpaq 2>&1")
  end
end
