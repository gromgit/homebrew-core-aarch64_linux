class Cfengine < Formula
  desc "Help manage and understand IT infrastructure"
  homepage "https://cfengine.com/"
  url "https://cfengine-package-repos.s3.amazonaws.com/tarballs/cfengine-3.15.0.tar.gz"
  sha256 "fa53e137f850eb268a8e7ae4578b5db5dc383656341f5053dc1a353ed0288265"

  bottle do
    rebuild 1
    sha256 "b931d7b1f10909c4d2cdb362497203213d84d26df5e5071707f341f85b4df27d" => :catalina
    sha256 "4eaaf194545c426f58117c2518f7a5db49b8265cd4000abec839bd70f4a9062c" => :mojave
    sha256 "a221af5677518fd309917b61878dc8ba571a3f364e872c7e0c672449d5429ba1" => :high_sierra
    sha256 "9a1aa88f5a4b42ad4a5d2df2439cd3a49aa272c26746f4ae25a810291aecbdcc" => :sierra
  end

  depends_on "lmdb"
  depends_on "openssl@1.1"
  depends_on "pcre"

  resource "masterfiles" do
    url "https://cfengine-package-repos.s3.amazonaws.com/tarballs/cfengine-masterfiles-3.15.0.tar.gz"
    sha256 "4a071c0c4ba7df9bad93144cff5fbc0566e5172afd66201072e3193b76c55a38"
  end

  def install
    system "./configure", "--disable-dependency-tracking",
                          "--prefix=#{prefix}",
                          "--with-workdir=#{var}/cfengine",
                          "--with-lmdb=#{Formula["lmdb"].opt_prefix}",
                          "--with-pcre=#{Formula["pcre"].opt_prefix}",
                          "--without-mysql",
                          "--without-postgresql"
    system "make", "install"
    (pkgshare/"CoreBase").install resource("masterfiles")
  end

  test do
    assert_equal "CFEngine Core #{version}", shell_output("#{bin}/cf-agent -V").chomp
  end
end
