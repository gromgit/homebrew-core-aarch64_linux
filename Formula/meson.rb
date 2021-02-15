class Meson < Formula
  desc "Fast and user friendly build system"
  homepage "https://mesonbuild.com/"
  url "https://github.com/mesonbuild/meson/releases/download/0.57.0/meson-0.57.0.tar.gz"
  sha256 "7ccb75fe1a4d404bcab86e72678abc7f75793401aa9054f881a4eb3cb990f5d9"
  license "Apache-2.0"
  head "https://github.com/mesonbuild/meson.git"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "db42e515588d9b32837274bcc9c4df31ac6c7e547c499fb991a4f44f84526e9b"
    sha256 cellar: :any_skip_relocation, big_sur:       "74a577f2b3e932a3b86cfa1800916bcf630769a7e0b4ae3a5e09226cd64887ff"
    sha256 cellar: :any_skip_relocation, catalina:      "89b921765419aa55c1affdb601434b541af957241af2312add80c630873037ea"
    sha256 cellar: :any_skip_relocation, mojave:        "820192fe3b9909c65ec5dbab1d76fc45c8d8e8406629f1209230c1fcb863a695"
  end

  depends_on "ninja"
  depends_on "python@3.9"

  def install
    version = Language::Python.major_minor_version Formula["python@3.9"].bin/"python3"
    ENV["PYTHONPATH"] = lib/"python#{version}/site-packages"

    system Formula["python@3.9"].bin/"python3", *Language::Python.setup_install_args(prefix)

    bin.env_script_all_files(libexec/"bin", PYTHONPATH: ENV["PYTHONPATH"])
  end

  test do
    (testpath/"helloworld.c").write <<~EOS
      main() {
        puts("hi");
        return 0;
      }
    EOS
    (testpath/"meson.build").write <<~EOS
      project('hello', 'c')
      executable('hello', 'helloworld.c')
    EOS

    mkdir testpath/"build" do
      system "#{bin}/meson", ".."
      assert_predicate testpath/"build/build.ninja", :exist?
    end
  end
end
