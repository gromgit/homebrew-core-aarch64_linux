class Diffutils < Formula
  desc "File comparison utilities"
  homepage "https://www.gnu.org/s/diffutils/"
  url "https://ftp.gnu.org/gnu/diffutils/diffutils-3.8.tar.xz"
  mirror "https://ftpmirror.gnu.org/diffutils/diffutils-3.8.tar.xz"
  sha256 "a6bdd7d1b31266d11c4f4de6c1b748d4607ab0231af5188fc2533d0ae2438fec"
  license "GPL-3.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "ffe8dc9603b805641fa3bedf9d33d50db10bcc47daaf1e0fec99a39184c2707c"
    sha256 cellar: :any_skip_relocation, big_sur:       "626485c5fb898eecdc93c2b2af1e98651662afd78181a8ce5683d59c8562ea2e"
    sha256 cellar: :any_skip_relocation, catalina:      "25a2f5fcdfcdf2efa36b97841e45455950fe322e1c642d97a36abbb2662007cf"
    sha256 cellar: :any_skip_relocation, mojave:        "4ec2a5ef0ca889d6c449b31ed43c797a0656ff7a2acfd913d0f87d8f14248031"
    sha256 cellar: :any_skip_relocation, high_sierra:   "fe012f4e981c3df3b2d1b3eb2b77009991148e3bdc08dd974d6f6071108e8937"
    sha256 cellar: :any_skip_relocation, sierra:        "3a04e2e2de81458a8fc75482a97a02883a1cdf231ee340ce30d9a712d0475305"
    sha256                               x86_64_linux:  "549c2e056804c0a8f89f6781cbf69d96359b290c12abd8dc4eb81ccba1bb902c"
  end

  def install
    system "./configure", "--disable-dependency-tracking", "--prefix=#{prefix}"
    system "make", "install"
  end

  test do
    (testpath/"a").write "foo"
    (testpath/"b").write "foo"
    system bin/"diff", "a", "b"
  end
end
