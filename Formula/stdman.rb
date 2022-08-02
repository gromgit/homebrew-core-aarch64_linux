class Stdman < Formula
  desc "Formatted C++ stdlib man pages from cppreference.com"
  homepage "https://github.com/jeaye/stdman"
  url "https://github.com/jeaye/stdman/archive/2022.07.30.tar.gz"
  sha256 "332383e5999e1ac9a6210be8b256608187bb7690a2bff990372e93c2ad4e76ff"
  license "MIT"
  version_scheme 1
  head "https://github.com/jeaye/stdman.git", branch: "master"

  bottle do
    rebuild 1
    sha256 cellar: :any_skip_relocation, all: "3a74e020e777587f893a2c62e7fda36ca37ba021206dbe0a57f29b9970ad6642"
  end

  on_linux do
    depends_on "man-db" => :test
  end

  def install
    system "./configure", "--prefix=#{prefix}"
    system "make", "install"
  end

  test do
    man = OS.mac? ? "man" : "gman"
    system man, "-w", "std::string"
  end
end
