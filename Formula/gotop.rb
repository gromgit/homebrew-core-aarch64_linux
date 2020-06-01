class Gotop < Formula
  desc "Terminal based graphical activity monitor inspired by gtop and vtop"
  homepage "https://github.com/xxxserxxx/gotop"
  url "https://github.com/xxxserxxx/gotop/archive/v3.5.3.tar.gz"
  sha256 "fd9ecc1f9fcd622dc88f93af87fdf6a12020cec424d742deb1865853b38d5605"

  bottle do
    cellar :any_skip_relocation
    sha256 "b58594789760418f414c59d6894b0fb65be0e6c187ba82abe16ef85b0352152b" => :catalina
    sha256 "6774800971a481e6376ac3e014ce1ca05d617b565e664dc1ce57655f1c9d1c98" => :mojave
    sha256 "9089ba9be47d82d4af9fec33575e43ce50aabf3676354484381ea23d5e6ba68a" => :high_sierra
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args, "./cmd/gotop"
  end

  test do
    assert_equal version.to_s, shell_output("#{bin}/gotop --version").chomp
  end
end
