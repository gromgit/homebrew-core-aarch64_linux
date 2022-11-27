class Draco < Formula
  desc "3D geometric mesh and point cloud compression library"
  homepage "https://google.github.io/draco/"
  url "https://github.com/google/draco/archive/1.5.3.tar.gz"
  sha256 "7882a942a1da14a9ae9d557b1a3af7f44bdee7f5d42b745c4e474fb8b28d4e5e"
  license "Apache-2.0"

  bottle do
    root_url "https://github.com/gromgit/homebrew-core-aarch64_linux/releases/download/draco"
    sha256 cellar: :any_skip_relocation, aarch64_linux: "54e03d89ba53e18206d4a3fa98e62f7bfc92d91a9fbf6324f142232f67d65c17"
  end

  depends_on "cmake" => :build

  def install
    mkdir "build" do
      system "cmake", "..", * std_cmake_args
      system "make", "install"
    end
    pkgshare.install "testdata/cube_att.ply"
  end

  test do
    system "#{bin}/draco_encoder", "-i", "#{pkgshare}/cube_att.ply",
           "-o", "cube_att.drc"
    assert_predicate testpath/"cube_att.drc", :exist?
  end
end
