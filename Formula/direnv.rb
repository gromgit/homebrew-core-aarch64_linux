class Direnv < Formula
  desc "Load/unload environment variables based on $PWD"
  homepage "https://direnv.net/"
  url "https://github.com/direnv/direnv/archive/v2.24.0.tar.gz"
  sha256 "a0993912bc6e89580bc8320d3c9b3e70ccd6aa06c1d847a4d9174bee8a8b9431"
  license "MIT"
  head "https://github.com/direnv/direnv.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "e727cb548c45ac0cb4f341f8f8c852bb24a42a29c8aedbe3c066a584f4957dea" => :big_sur
    sha256 "6c1ad71d50c04dc82edf046c343c27a822cec108b6968306a8e5e656c7dbf8d9" => :catalina
    sha256 "67ae040f4951625ea19f26108ffe3681756c85d9aa3d0c0808802f7c18d0dcc1" => :mojave
    sha256 "4a185e12bb5400949dd1e968f71c29e6d657f4e9dcf829fb51f08eb483dc3fba" => :high_sierra
  end

  depends_on "go" => :build

  def install
    system "make", "install", "DESTDIR=#{prefix}"
  end

  test do
    system bin/"direnv", "status"
  end
end
