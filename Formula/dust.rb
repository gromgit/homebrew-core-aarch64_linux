class Dust < Formula
  desc "More intuitive version of du in rust"
  homepage "https://github.com/bootandy/dust"
  url "https://github.com/bootandy/dust/archive/v0.5.0.tar.gz"
  sha256 "a68bb45a1e6eac63935070f3e0381ccf015c9c30710659bc38b55c60cdba5917"
  head "https://github.com/bootandy/dust.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "4e64436e27571f1f365f8b898dcb96e056f9b62093f8fa2bf688bddc78e37602" => :catalina
    sha256 "80b33402c9968fdc6cd540e34a39fb4cbccde5a3beadcca01a9714e2ef167e19" => :mojave
    sha256 "d3eef9ecd143677d47626fb24ad9e7c25a3eee4e59f72b3e2065f7dda2a5bf2c" => :high_sierra
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", "--locked", "--root", prefix, "--path", "."
  end

  test do
    assert_match /\d+.+?\./, shell_output("#{bin}/dust -n 1")
  end
end
