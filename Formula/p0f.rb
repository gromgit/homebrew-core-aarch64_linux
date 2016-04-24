class P0f < Formula
  desc "Versatile passive OS fingerprinting, masquerade detection tool"
  homepage "http://lcamtuf.coredump.cx/p0f3/"
  url "http://lcamtuf.coredump.cx/p0f3/releases/p0f-3.09b.tgz"
  sha256 "543b68638e739be5c3e818c3958c3b124ac0ccb8be62ba274b4241dbdec00e7f"

  bottle do
    cellar :any_skip_relocation
    sha256 "0cb866d5486e0e8f3583f5acb2d2ce18ad346511caa8f3ecbace50d3ddb601f1" => :el_capitan
    sha256 "7405d2d0d6070223be3cc0f2ed11c8cd52d886b1480931c1a7e9436d297dbbe7" => :yosemite
    sha256 "113e04c8f1fba685b42620838cb7fa6907431ff8b4f88ed5ab620f67a7a3aca1" => :mavericks
    sha256 "cced7b6bab2cdd563d47c6734efb170eb23e3295f25eedaf3294d78ad8812999" => :mountain_lion
  end

  def install
    inreplace "config.h", "p0f.fp", "#{etc}/p0f/p0f.fp"
    system "./build.sh"
    sbin.install "p0f"
    (etc/"p0f").install "p0f.fp"
  end

  test do
    system "#{sbin}/p0f", "-r", test_fixtures("test.pcap")
  end
end
