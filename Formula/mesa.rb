class Mesa < Formula
  desc "Graphics Library"
  homepage "https://www.mesa3d.org/"
  url "https://mesa.freedesktop.org/archive/mesa-20.1.1.tar.xz"
  mirror "https://www.mesa3d.org/archive/mesa-20.1.1.tar.xz"
  sha256 "3ea6e46ea7881c656f7b4724639eaa4672d4e0e0b70869651e8f955ebae3d476"
  head "https://gitlab.freedesktop.org/mesa/mesa.git"

  bottle do
    cellar :any
    sha256 "92b7bd991ed224369f30bce554d38c5b3528e5a3f50a1a998f79ead055e685ab" => :catalina
    sha256 "dcdd217b01307e24e1f90dad0de2f2d07bf68d2de25cd23388b2e3a3d9385d8d" => :mojave
    sha256 "e670124c03db8becfe7b8d883c5b6027fb2922f01d52a51a3b2f2958f0f59075" => :high_sierra
  end

  depends_on "meson-internal" => :build
  depends_on "ninja" => :build
  depends_on "pkg-config" => :build
  depends_on "python@3.8" => :build
  depends_on "freeglut" => :test
  depends_on "expat"
  depends_on "gettext"

  resource "Mako" do
    url "https://files.pythonhosted.org/packages/72/89/402d2b4589e120ca76a6aed8fee906a0f5ae204b50e455edd36eda6e778d/Mako-1.1.3.tar.gz"
    sha256 "8195c8c1400ceb53496064314c6736719c6f25e7479cd24c77be3d9361cddc27"
  end

  resource "gears.c" do
    url "https://www.opengl.org/archives/resources/code/samples/glut_examples/mesademos/gears.c"
    sha256 "7df9d8cda1af9d0a1f64cc028df7556705d98471fdf3d0830282d4dcfb7a78cc"
  end

  def install
    python3 = Formula["python@3.8"].opt_bin/"python3"
    xy = Language::Python.major_minor_version python3
    ENV.prepend_create_path "PYTHONPATH", buildpath/"vendor/lib/python#{xy}/site-packages"

    resource("Mako").stage do
      system python3, *Language::Python.setup_install_args(buildpath/"vendor")
    end

    resource("gears.c").stage(pkgshare.to_s)

    mkdir "build" do
      system "meson", *std_meson_args, "..", "-Dbuildtype=plain", "-Db_ndebug=true",
                      "-Dplatforms=surfaceless", "-Dglx=disabled"
      system "ninja"
      system "ninja", "install"
    end
  end

  test do
    flags = %W[
      -framework OpenGL
      -I#{Formula["freeglut"].opt_include}
      -L#{Formula["freeglut"].opt_lib}
      -lglut
    ]
    system ENV.cc, "#{pkgshare}/gears.c", "-o", "gears", *flags
  end
end
