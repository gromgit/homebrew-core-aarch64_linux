class VapoursynthOcr < Formula
  desc "VapourSynth filters - Tesseract OCR filter"
  homepage "https://www.vapoursynth.com"
  url "https://github.com/vapoursynth/vs-ocr/archive/R1.tar.gz"
  sha256 "a551354c78fdbe9bcaf29f9a29ee9a7d257ed74d1b6a8403049fcd57855fa0f4"
  license "MIT"
  version_scheme 1

  head "https://github.com/vapoursynth/vs-ocr.git", branch: "master"

  livecheck do
    formula "vapoursynth"
  end

  bottle do
    sha256 cellar: :any, arm64_big_sur: "0ee61239f71e594c05f6a93b675b9863ab53227715c355ef9b75ca1f92e577d5"
    sha256 cellar: :any, big_sur:       "c73eea38acf6dde0e271aa71393020d8f76c9c1c48607048c14b2ca53616d629"
    sha256 cellar: :any, catalina:      "939098378976ede311e6b3158928a64bdf2fc1283655c2349501bec9bcd3d2d8"
    sha256 cellar: :any, mojave:        "708071510107a61e077d3ff47019c32120c65cfcc91e8265ae2e692f04d490f3"
  end

  depends_on "meson" => :build
  depends_on "ninja" => :build
  depends_on "pkg-config" => :build
  depends_on "tesseract"
  depends_on "vapoursynth"

  # Upstream has added a build system, but it's not present in the current release.
  # Remove patch on next update.
  patch do
    url "https://github.com/vapoursynth/vs-ocr/commit/d1e80c6a9d6efe7921300c01ffc0f311927ba443.patch?full_index=1"
    sha256 "6d4ec06e2d3dd5a2b071035775e76475e108cd191f9302ee89b3973420d69925"
  end

  def install
    # Upstream build system wants to install directly into vapoursynth's libdir and does not respect
    # prefix, but we want it in a Cellar location instead.
    inreplace "meson.build",
      "install_dir : join_paths(vapoursynth_dep.get_pkgconfig_variable('libdir'), 'vapoursynth')",
      "install_dir : '#{lib}/vapoursynth'"

    mkdir "build" do
      system "meson", *std_meson_args, ".."
      system "ninja", "-v"
      system "ninja", "install", "-v"
    end
  end

  test do
    system Formula["python@3.9"].opt_bin/"python3", "-c", "from vapoursynth import core; core.ocr"
  end
end
