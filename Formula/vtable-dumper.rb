class VtableDumper < Formula
  desc "List contents of virtual tables in a shared library"
  homepage "https://github.com/lvc/vtable-dumper"
  url "https://github.com/lvc/vtable-dumper/archive/1.2.tar.gz"
  sha256 "6993781b6a00936fc5f76dc0db4c410acb46b6d6e9836ddbe2e3c525c6dd1fd2"
  license "LGPL-2.1-or-later"

  bottle do
    root_url "https://github.com/gromgit/homebrew-core-aarch64_linux/releases/download/vtable-dumper"
    sha256 cellar: :any_skip_relocation, aarch64_linux: "ee9605a188935f50cdf3290ac44a1ffadc284ea5a92e7052c0a4af0f9a31c931"
  end


  depends_on "elfutils"
  depends_on :linux

  def install
    system "make", "prefix=#{prefix}", "install"
  end

  test do
    libstdcxx = Pathname.glob("/usr/**/libstdc++.so.6").first
    assert_match(/: \d+ entries/, shell_output("#{bin}/vtable-dumper #{libstdcxx}"))
  end
end
