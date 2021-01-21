class Xmake < Formula
  desc "Cross-platform build utility based on Lua"
  homepage "https://xmake.io/"
  url "https://github.com/xmake-io/xmake/releases/download/v2.5.1/xmake-v2.5.1.tar.gz"
  sha256 "809347dcd08659490c71a883198118e5484b271c452c02feb4c67551ef56c320"
  license "Apache-2.0"
  head "https://github.com/xmake-io/xmake.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "304929df3becb98dbb71c977c378c7bee7a82b625e4829178d744ecba9733df8" => :big_sur
    sha256 "2934592e40f18bfa65bd290b7343a30178117e8f88a4a344745774760fc8cbba" => :arm64_big_sur
    sha256 "5b43f0aecef9254ea7d2f8bcff909165d6b3dce3f7c93afe8294a429173596bd" => :catalina
    sha256 "66edef034918bdaec425876134c341d6092f1fd83e346403d14b23ac483c906d" => :mojave
  end

  on_linux do
    depends_on "readline"
  end

  def install
    on_linux do
      ENV["XMAKE_ROOT"] = "y" if ENV["CI"]
    end

    system "make"
    system "make", "install", "prefix=#{prefix}"
  end

  test do
    system bin/"xmake", "create", "test"
    cd "test" do
      system bin/"xmake"
      assert_equal "hello world!", shell_output("#{bin}/xmake run").chomp
    end
  end
end
