class Meson < Formula
  desc "Fast and user friendly build system"
  homepage "https://mesonbuild.com/"
  url "https://github.com/mesonbuild/meson/releases/download/0.59.0/meson-0.59.0.tar.gz"
  sha256 "e376c298df64b643dfe01eccb2d7b6f1e02e95aa38c19f19d120d129612ce476"
  license "Apache-2.0"
  head "https://github.com/mesonbuild/meson.git"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "7cd3369471574d895b0fa4b5f918ee0f0768082783df8b1030536e1fe435f7a0"
    sha256 cellar: :any_skip_relocation, big_sur:       "a4a69b17bb926a1e1f2c909adb1f4ba58a536c0f742dd40c4e2fb451859fb4a3"
    sha256 cellar: :any_skip_relocation, catalina:      "a4a69b17bb926a1e1f2c909adb1f4ba58a536c0f742dd40c4e2fb451859fb4a3"
    sha256 cellar: :any_skip_relocation, mojave:        "a4a69b17bb926a1e1f2c909adb1f4ba58a536c0f742dd40c4e2fb451859fb4a3"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "7cd3369471574d895b0fa4b5f918ee0f0768082783df8b1030536e1fe435f7a0"
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
