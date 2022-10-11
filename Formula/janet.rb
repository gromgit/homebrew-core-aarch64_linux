class Janet < Formula
  desc "Dynamic language and bytecode vm"
  homepage "https://janet-lang.org"
  url "https://github.com/janet-lang/janet/archive/v1.25.0.tar.gz"
  sha256 "5bf9b680adbc5511835aec3787117df37032eef796e1664edbbcfd540b6acaf3"
  license "MIT"
  head "https://github.com/janet-lang/janet.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_monterey: "02d83701ffecdd0a63f3a0c4e69b8aa7b077172595722d91b958066031201bcf"
    sha256 cellar: :any,                 arm64_big_sur:  "a5477c75138b52d24f19a2456aecc038c65826df3686ce3fbc66b7d24110a149"
    sha256 cellar: :any,                 monterey:       "8eaeb16dc792991d2bd36b1981c8af95e80fb117725d9f1de0f3a1018adc2e2c"
    sha256 cellar: :any,                 big_sur:        "0614dfad4fc13821cfb2c7f955180ed316f936543ff10bad76c203ce23f72ca0"
    sha256 cellar: :any,                 catalina:       "9d0132b9cf266cbddea365122a5d456dc00301287a96f402ed6c1034448ef812"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "e39e559b8ccbaede77948ec8a73566e9654ec412bae9ad10184144749da10b6b"
  end

  depends_on "meson" => :build
  depends_on "ninja" => :build

  resource "jpm" do
    url "https://github.com/janet-lang/jpm/archive/refs/tags/v1.1.0.tar.gz"
    sha256 "337c40d9b8c087b920202287b375c2962447218e8e127ce3a5a12e6e47ac6f16"
  end

  def install
    system "meson", "setup", "build", *std_meson_args
    cd "build" do
      system "ninja"
      system "ninja", "install"
    end
    ENV["PREFIX"] = prefix
    resource("jpm").stage do
      system bin/"janet", "bootstrap.janet"
    end
  end

  test do
    assert_equal "12", shell_output("#{bin}/janet -e '(print (+ 5 7))'").strip
    assert_predicate HOMEBREW_PREFIX/"bin/jpm", :exist?, "jpm must exist"
    assert_predicate HOMEBREW_PREFIX/"bin/jpm", :executable?, "jpm must be executable"
    assert_match prefix.to_s, shell_output("#{bin}/jpm show-paths")
  end
end
