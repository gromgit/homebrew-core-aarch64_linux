class Janet < Formula
  desc "Dynamic language and bytecode vm"
  homepage "https://janet-lang.org"
  url "https://github.com/janet-lang/janet/archive/v1.15.0.tar.gz"
  sha256 "e2cf16b330e47c858a675ac79b5a0af83727ff041efcb133a80f36bedfae57c4"
  license "MIT"
  head "https://github.com/janet-lang/janet.git"

  bottle do
    sha256 cellar: :any, arm64_big_sur: "3fdd21a0267f9f791d88f0088c04ea989e8bd7867969f1c54fb596c6d1feefc5"
    sha256 cellar: :any, big_sur:       "75e53b9ad08c33c511958112ac1b93e1b8e111659827fd32d8dc5147136cee60"
    sha256 cellar: :any, catalina:      "d64943b91a284260e87545d398649d2c894408d36cec30db1520f64088f29fde"
    sha256 cellar: :any, mojave:        "290d07100ea1e65cc9e5180e60f3bf3c0c7f7f3d548221819ba5ae41736359c9"
  end

  depends_on "meson" => :build
  depends_on "ninja" => :build

  def install
    system "meson", "setup", "build", *std_meson_args
    cd "build" do
      system "ninja"
      system "ninja", "install"
    end
  end

  test do
    assert_equal "12", shell_output("#{bin}/janet -e '(print (+ 5 7))'").strip
  end
end
