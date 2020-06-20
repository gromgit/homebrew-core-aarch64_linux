class SwitchLanPlay < Formula
  desc "Make you and your friends play games like in a LAN"
  homepage "https://github.com/spacemeowx2/switch-lan-play"
  url "https://github.com/spacemeowx2/switch-lan-play.git",
    :tag      => "v0.2.2",
    :revision => "1c4d887b7aae1fa3c4af68a89590f7608d99773d"

  bottle do
    cellar :any_skip_relocation
    sha256 "c8e615d0b5acbbd3696f283b5824fab39ae8888c283b65bbf2aa7049080061b4" => :catalina
    sha256 "3dc79868207b00d684f176a84f7539e6cd7fc3ddca9f37ac492dd160b9e5db28" => :mojave
    sha256 "9db070fc867633a50f08051962f978895f087a9d29efd6b1c9e2879ba8c830a2" => :high_sierra
  end

  depends_on "cmake" => :build

  def install
    mkdir "build" do
      system "cmake", "..", *std_cmake_args
      system "make", "install"
    end
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/lan-play --version")
    assert_match "1.", shell_output("#{bin}/lan-play --list-if")
  end
end
