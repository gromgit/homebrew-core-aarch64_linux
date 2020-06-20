class SwitchLanPlay < Formula
  desc "Make you and your friends play games like in a LAN"
  homepage "https://github.com/spacemeowx2/switch-lan-play"
  url "https://github.com/spacemeowx2/switch-lan-play.git",
    :tag      => "v0.2.2",
    :revision => "1c4d887b7aae1fa3c4af68a89590f7608d99773d"

  bottle do
    cellar :any_skip_relocation
    sha256 "4779cc387bc9579f449129eeff23c8dbfacd0e7d9b93cc1c9a1022cc9373c579" => :catalina
    sha256 "f6c0989523969ba660a0a505d1a02bb6e833a8a5e9805caa4f707b63c3b13021" => :mojave
    sha256 "8d0b2c53cbca55c02fd6c85ebb32259069051817dc2432e70c1843cf6a296bd9" => :high_sierra
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
