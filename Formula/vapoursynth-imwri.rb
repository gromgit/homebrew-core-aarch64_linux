class VapoursynthImwri < Formula
  desc "VapourSynth filters - ImageMagick HDRI writer/reader"
  homepage "https://github.com/vapoursynth/vs-imwri"
  url "https://github.com/vapoursynth/vs-imwri/archive/R1.tar.gz"
  sha256 "6eed24a7fda9e4ff80f5f866fa87a63c5ba9ad600318d05684eec18e40ad931f"
  license "LGPL-2.1-or-later"
  version_scheme 1

  head "https://github.com/vapoursynth/vs-imwri.git", branch: "master"

  livecheck do
    formula "vapoursynth"
  end

  bottle do
    sha256 cellar: :any, arm64_big_sur: "5836132cd53eaa1767021d26597b1cfd3108f342abe0cad7f1ce40dd3fb6511d"
    sha256 cellar: :any, big_sur:       "01ffc95970768ce9c4b3197a0f60c51083299c44e8a46e596e85c31dc98c07a9"
    sha256 cellar: :any, catalina:      "2b0b833b8f808b3748249dc12a94a82394b5b4cd0ab4cbf4d2b092e491bf8b9f"
    sha256 cellar: :any, mojave:        "0bb81d8870a76270aff989d487896f0d651f7e13739c5598e9be9e9aa6cc633a"
  end

  depends_on "meson" => :build
  depends_on "ninja" => :build
  depends_on "pkg-config" => :build
  depends_on "imagemagick"
  depends_on "vapoursynth"

  on_linux do
    depends_on "gcc"
  end

  fails_with gcc: "5"

  def install
    # Upstream build system wants to install directly into vapoursynth's libdir and does not respect
    # prefix, but we want it in a Cellar location instead.
    inreplace "meson.build",
              "install_dir = vapoursynth_dep.get_variable(pkgconfig: 'libdir') / 'vapoursynth'",
              "install_dir = '#{lib}/vapoursynth'"

    mkdir "build" do
      system "meson", *std_meson_args, ".."
      system "ninja", "-v"
      system "ninja", "install", "-v"
    end
  end

  test do
    system Formula["python@3.9"].opt_bin/"python3", "-c", "from vapoursynth import core; core.imwri"
  end
end
