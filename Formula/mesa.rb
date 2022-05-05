class Mesa < Formula
  include Language::Python::Virtualenv

  desc "Graphics Library"
  homepage "https://www.mesa3d.org/"
  url "https://mesa.freedesktop.org/archive/mesa-22.0.3.tar.xz"
  sha256 "9f2b30f5276a9abaf71aafc6979685e2636189de1a87aea2c9e69744a6d0ebb9"
  license "MIT"
  head "https://gitlab.freedesktop.org/mesa/mesa.git", branch: "main"

  bottle do
    sha256 arm64_monterey: "dee240e5c0797337cfdac4d9cf729c3c72c53311528fa1c57c5e229241c5e484"
    sha256 arm64_big_sur:  "04dd9c5d74b2ad7625bbe00d1bbfed738817f294d9f34c72bdefcb759820a479"
    sha256 monterey:       "d8450dad1293d142d164323bc3c12675804b556ef82fb47184ee920bda176955"
    sha256 big_sur:        "7bc616b59aa2def2905d14748a45ca744e1864631abd6fc0af67ca7689f74273"
    sha256 catalina:       "8db83bbc560f8e9bd3c86e04c5b7628a1c173b837bccf51f521aca32cc19ad8d"
    sha256 x86_64_linux:   "8130aaa5fea3c99babbd53d05603bd478afc9dbf01413367658ea9217a4e30f4"
  end

  depends_on "meson" => :build
  depends_on "ninja" => :build
  depends_on "pkg-config" => :build
  depends_on "python@3.10" => :build
  depends_on "expat"
  depends_on "gettext"
  depends_on "libx11"
  depends_on "libxcb"
  depends_on "libxdamage"
  depends_on "libxext"

  uses_from_macos "bison" => :build
  uses_from_macos "flex" => :build
  uses_from_macos "llvm"
  uses_from_macos "ncurses"
  uses_from_macos "zlib"

  on_linux do
    depends_on "elfutils"
    depends_on "gcc"
    depends_on "gzip"
    depends_on "libdrm"
    depends_on "libva"
    depends_on "libvdpau"
    depends_on "libxfixes"
    depends_on "libxrandr"
    depends_on "libxshmfence"
    depends_on "libxv"
    depends_on "libxvmc"
    depends_on "libxxf86vm"
    depends_on "lm-sensors"
    depends_on "wayland"
    depends_on "wayland-protocols"
  end

  fails_with gcc: "5"

  resource "Mako" do
    url "https://files.pythonhosted.org/packages/50/ec/1d687348f0954bda388bfd1330c158ba8d7dea4044fc160e74e080babdb9/Mako-1.2.0.tar.gz"
    sha256 "9a7c7e922b87db3686210cf49d5d767033a41d4010b284e747682c92bddd8b39"
  end

  resource "Pygments" do
    url "https://files.pythonhosted.org/packages/94/9c/cb656d06950268155f46d4f6ce25d7ffc51a0da47eadf1b164bbf23b718b/Pygments-2.11.2.tar.gz"
    sha256 "4e426f72023d88d03b2fa258de560726ce890ff3b630f88c21cbb8b2503b8c6a"
  end

  resource "MarkupSafe" do
    url "https://files.pythonhosted.org/packages/1d/97/2288fe498044284f39ab8950703e88abbac2abbdf65524d576157af70556/MarkupSafe-2.1.1.tar.gz"
    sha256 "7f91197cc9e48f989d12e4e6fbc46495c446636dfc81b9ccf50bb0ec74b91d4b"
  end

  resource "glxgears.c" do
    url "https://gitlab.freedesktop.org/mesa/demos/-/raw/db5ad06a346774a249b22797e660d55bde0d9571/src/xdemos/glxgears.c"
    sha256 "3873db84d708b5d8b3cac39270926ba46d812c2f6362da8e6cd0a1bff6628ae6"
  end

  resource "gl_wrap.h" do
    url "https://gitlab.freedesktop.org/mesa/demos/-/raw/5435fc7fbd332e171da9a71e33a9b190e9462cf0/src/util/gl_wrap.h"
    sha256 "c727b2341d81c2a1b8a0b31e46d24f9702a1ec55c8be3f455ddc8d72120ada72"
  end

  def install
    ENV.prepend_path "PATH", Formula["python@3.10"].opt_libexec/"bin"

    venv_root = buildpath/"venv"
    venv = virtualenv_create(venv_root, "python3")

    %w[Mako Pygments MarkupSafe].each do |res|
      venv.pip_install resource(res)
    end

    ENV.prepend_path "PATH", "#{venv_root}/bin"

    mkdir "build" do
      args = ["-Db_ndebug=true"]

      if OS.linux?
        args << "-Dplatforms=x11,wayland"
        args << "-Dglx=auto"
        args << "-Ddri3=true"
        args << "-Dgallium-drivers=auto"
        args << "-Dgallium-omx=disabled"
        args << "-Degl=true"
        args << "-Dgbm=true"
        args << "-Dopengl=true"
        args << "-Dgles1=enabled"
        args << "-Dgles2=enabled"
        args << "-Dgallium-xvmc=disabled"
        args << "-Dvalgrind=false"
        args << "-Dtools=drm-shim,etnaviv,freedreno,glsl,nir,nouveau,xvmc,lima"
      end

      system "meson", *std_meson_args, "..", *args
      system "ninja"
      system "ninja", "install"
    end

    if OS.linux?
      # Strip executables/libraries/object files to reduce their size
      system("strip", "--strip-unneeded", "--preserve-dates", *(Dir[bin/"**/*", lib/"**/*"]).select do |f|
        f = Pathname.new(f)
        f.file? && (f.elf? || f.extname == ".a")
      end)
    end
  end

  test do
    %w[glxgears.c gl_wrap.h].each { |r| resource(r).stage(testpath) }
    flags = %W[
      -I#{include}
      -L#{lib}
      -L#{Formula["libx11"].lib}
      -L#{Formula["libxext"].lib}
      -lGL
      -lX11
      -lXext
      -lm
    ]
    system ENV.cc, "glxgears.c", "-o", "gears", *flags
  end
end
