class Cmix < Formula
  desc "Data compression program with high compression ratio"
  homepage "https://www.byronknoll.com/cmix.html"
  url "https://github.com/byronknoll/cmix/archive/v18.tar.gz"
  version "18.0.0"
  sha256 "2f0272186a8ff693146d0d8070ad4d9687461a486805ab91d727891df316498d"
  license "GPL-3.0"

  bottle do
    root_url "https://github.com/gromgit/homebrew-core-aarch64_linux/releases/download/cmix"
    sha256 cellar: :any_skip_relocation, aarch64_linux: "ef93a1c8f8a2919638ccfa77d798b7bb7aa38b858e06d6d1bf2560074407a991"
  end

  def install
    system "make"
    bin.install "cmix"
  end

  test do
    (testpath/"foo").write "test"
    system "#{bin}/cmix", "-c", "foo", "foo.cmix"
    system "#{bin}/cmix", "-d", "foo.cmix", "foo.unpacked"
    assert_equal "test", shell_output("cat foo.unpacked")
  end
end
