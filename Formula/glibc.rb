require "os/linux/glibc"

class BrewedGlibcNotOlderRequirement < Requirement
  fatal true

  satisfy(build_env: false) do
    Glibc.version >= OS::Linux::Glibc.system_version
  end

  def message
    <<~EOS
      Your system's glibc version is #{OS::Linux::Glibc.system_version}, and Homebrew's glibc version is #{Glibc.version}.
      Installing a version of glibc that is older than your system's can break formulae installed from source.
    EOS
  end

  def display_s
    "System glibc < #{Glibc.version}"
  end
end

class LinuxKernelRequirement < Requirement
  fatal true

  MINIMUM_LINUX_KERNEL_VERSION = "2.6.32".freeze

  satisfy(build_env: false) do
    OS.kernel_version >= MINIMUM_LINUX_KERNEL_VERSION
  end

  def message
    <<~EOS
      Linux kernel version #{MINIMUM_LINUX_KERNEL_VERSION} or later is required by glibc.
      Your system has Linux kernel version #{OS.kernel_version}.
    EOS
  end

  def display_s
    "Linux kernel #{MINIMUM_LINUX_KERNEL_VERSION} (or later)"
  end
end

class Glibc < Formula
  desc "GNU C Library"
  homepage "https://www.gnu.org/software/libc/"
  url "https://ftp.gnu.org/gnu/glibc/glibc-2.35.tar.gz"
  sha256 "3e8e0c6195da8dfbd31d77c56fb8d99576fb855fafd47a9e0a895e51fd5942d4"
  license all_of: ["GPL-2.0-or-later", "LGPL-2.1-or-later"]

  livecheck do
    skip "glibc is pinned to the version present in Homebrew CI"
  end

  bottle do
    root_url "https://github.com/gromgit/homebrew-core-aarch64_linux/releases/download/glibc"
    sha256 aarch64_linux: "d1cf8e38f3cdcb8ad75fd175e5422f8842abb1c5fa2a1f726e85c20cb65740dc"
  end

  depends_on "linux-headers@5.15" => :build
  depends_on BrewedGlibcNotOlderRequirement
  depends_on :linux
  depends_on LinuxKernelRequirement

  # Automatic bootstrapping is only supported for Intel.
  on_intel do
    resource "bootstrap-binutils" do
      url "https://github.com/Homebrew/glibc-bootstrap/releases/download/1.0.0/bootstrap-binutils-2.38.tar.gz"
      sha256 "a2971fd77743a1d82242736c646bfa201137a4df28d829b1aa7f556fc57215e2"
    end

    resource "bootstrap-bison" do
      url "https://github.com/Homebrew/glibc-bootstrap/releases/download/1.0.0/bootstrap-bison-3.8.2.tar.gz"
      sha256 "f914c0dee9fc8a200f6607d52a2d25c253b665d02aaac360711ebd5fbd9cb346"
    end

    resource "bootstrap-gawk" do
      url "https://github.com/Homebrew/glibc-bootstrap/releases/download/1.0.0/bootstrap-gawk-5.1.1.tar.gz"
      sha256 "ec3f0115b156b418a189f9868aaa0655f18c40f5c40f437e407ac60b7c749e0a"
    end

    resource "bootstrap-gcc" do
      url "https://github.com/Homebrew/glibc-bootstrap/releases/download/1.0.0/bootstrap-gcc-9.5.0.tar.gz"
      sha256 "d549cf096864de5da77b4f068fab3741636206f3b7ace593b46a226d726f4538"
    end

    resource "bootstrap-make" do
      url "https://github.com/Homebrew/glibc-bootstrap/releases/download/1.0.0/bootstrap-make-4.3.tar.gz"
      sha256 "aa684eff83e5a986391475547c29b3ade04a307aa5730866aa5d2caa905e7166"
    end

    resource "bootstrap-python3" do
      url "https://github.com/Homebrew/glibc-bootstrap/releases/download/1.0.0/bootstrap-python3-3.9.13.tar.gz"
      sha256 "93d258ab9240d247a66322926deb6728e2aa7877711196fde02d716c20ada490"
    end

    resource "bootstrap-sed" do
      url "https://github.com/Homebrew/glibc-bootstrap/releases/download/1.0.0/bootstrap-sed-4.8.tar.gz"
      sha256 "404f86a92a15303f9b08960712ee8a8b398efc345d80b4e0401dd9ef82452046"
    end
  end
  on_arm do
    resource "bootstrap-binutils" do
      url "https://github.com/gromgit/glibc-bootstrap/releases/download/0.1.0/bootstrap-binutils-2.38.aarch64_linux.tar.gz"
      sha256 "693b1e59491c8d5a658dfc800f2cdc02aadf5bc2e21eca959b697460ca0af1a8"
    end

    resource "bootstrap-bison" do
      url "https://github.com/gromgit/glibc-bootstrap/releases/download/0.1.0/bootstrap-bison-3.8.2.aarch64_linux.tar.gz"
      sha256 "e5b2501350a2221ddab1de2c5968cdede48e99e72c622e358043d5ef8fce3fd2"
    end

    resource "bootstrap-gawk" do
      url "https://github.com/gromgit/glibc-bootstrap/releases/download/0.1.0/bootstrap-gawk-5.1.1.aarch64_linux.tar.gz"
      sha256 "7e50c6bdbe4f0575b9bb57355d919fd45e91a8433a078b8f8fd8203aad5a5f3c"
    end

    resource "bootstrap-gcc" do
      url "https://github.com/gromgit/glibc-bootstrap/releases/download/0.1.0/bootstrap-gcc-9.5.0.aarch64_linux.tar.gz"
      sha256 "151380d82ca5fb63d451e0654c566e4c57546f424fd77701789f0716565a5919"
    end

    resource "bootstrap-make" do
      url "https://github.com/gromgit/glibc-bootstrap/releases/download/0.1.0/bootstrap-make-4.3.aarch64_linux.tar.gz"
      sha256 "4039f5c96e859af1d66a3d9f29b46ed55cd6334b2cc8f0a558f6e4311763eb52"
    end

    resource "bootstrap-python3" do
      url "https://github.com/gromgit/glibc-bootstrap/releases/download/0.1.0/bootstrap-python3-3.9.13.aarch64_linux.tar.gz"
      sha256 "0547b57a32c33df053ee99ce09dc8e7cb95ddeb16b7e126bfb9a593ef3352d26"
    end

    resource "bootstrap-sed" do
      url "https://github.com/gromgit/glibc-bootstrap/releases/download/0.1.0/bootstrap-sed-4.8.aarch64_linux.tar.gz"
      sha256 "38da0149a9f1f0e175ec15356d15de278ffc2ded7b07846e295dc0587e1511d4"
    end
  end

  def install
    # Automatic bootstrapping is only supported for Intel.
    #if Hardware::CPU.intel?
      # Set up bootstrap resources in /tmp/homebrew.
      bootstrap_dir = Pathname.new("/tmp/homebrew")
      bootstrap_dir.mkpath

      resources.each do |r|
        r.stage do
          cp_r Pathname.pwd.children, bootstrap_dir
        end
      end

      # Add bootstrap resources to PATH.
      ENV.prepend_path "PATH", bootstrap_dir/"bin"
      # Make sure we use the bootstrap GCC rather than other compilers.
      ENV["CC"] = bootstrap_dir/"bin/gcc"
      ENV["CXX"] = bootstrap_dir/"bin/g++"
      # The MAKE variable must be set to the bootstrap make - including it in the path is not enough.
      ENV["MAKE"] = bootstrap_dir/"bin/make"
      # Add -march=core2 and -O2 when building in CI since we are not using the compiler shim.
      ENV.append "CFLAGS", "-march=core2 -O2" if ENV["HOMEBREW_GITHUB_ACTIONS"]
    #end

    # Setting RPATH breaks glibc.
    %w[
      LDFLAGS LD_LIBRARY_PATH LD_RUN_PATH LIBRARY_PATH
      HOMEBREW_DYNAMIC_LINKER HOMEBREW_LIBRARY_PATHS HOMEBREW_RPATH_PATHS
    ].each { |x| ENV.delete x }

    # Use brewed ld.so.preload rather than the hotst's /etc/ld.so.preload
    inreplace "elf/rtld.c", '= "/etc/ld.so.preload";', '= SYSCONFDIR "/ld.so.preload";'

    mkdir "build" do
      args = [
        "--disable-crypt",
        "--disable-debug",
        "--disable-dependency-tracking",
        "--disable-silent-rules",
        "--prefix=#{prefix}",
        "--enable-obsolete-rpc",
        "--without-gd",
        "--without-selinux",
        "--with-binutils=#{bootstrap_dir}/bin",
        "--with-headers=#{Formula["linux-headers@5.15"].include}",
      ]
      system "../configure", *args
      system "make", "all"
      system "make", "install"
      prefix.install_symlink "lib" => "lib64"
    end

    # Delete bootstrap binaries after build is finished.
    rm_rf bootstrap_dir
  end

  def post_install
    # Install ld.so symlink.
    ld_so = Hardware::CPU.intel? ? "ld-linux-x86-64.so.2" : "ld-linux-aarch64.so.1"
    ohai "Linking #{ld_so}"
    ln_sf lib/ld_so, HOMEBREW_PREFIX/"lib/ld.so"

    # Compile locale definition files
    mkdir_p lib/"locale"

    # Get all extra installed locales from the system, except C locales
    locales = ENV.map do |k, v|
      v if k[/^LANG$|^LC_/] && v != "C" && !v.start_with?("C.")
    end.compact

    # en_US.UTF-8 is required by gawk make check
    locales = (locales + ["en_US.UTF-8"]).sort.uniq
    ohai "Installing locale data for #{locales.join(" ")}"
    locales.each do |locale|
      lang, charmap = locale.split(".", 2)
      if charmap.present?
        charmap = "UTF-8" if charmap == "utf8"
        system bin/"localedef", "-i", lang, "-f", charmap, locale
      else
        system bin/"localedef", "-i", lang, locale
      end
    end

    # Set the local time zone
    sys_localtime = Pathname("/etc/localtime")
    brew_localtime = prefix/"etc/localtime"
    (prefix/"etc").install_symlink sys_localtime if sys_localtime.exist? && brew_localtime.exist?

    # Set zoneinfo correctly using the system installed zoneinfo
    sys_zoneinfo = Pathname("/usr/share/zoneinfo")
    brew_zoneinfo = share/"zoneinfo"
    share.install_symlink sys_zoneinfo if sys_zoneinfo.exist? && !brew_zoneinfo.exist?
  end

  test do
    ld_so = Hardware::CPU.intel? ? "ld-linux-x86-64.so.2" : "ld-linux-aarch64.so.1"
    assert_match "Usage", shell_output("#{lib}/#{ld_so} --help")
    safe_system "#{lib}/libc.so.6", "--version"
    safe_system "#{bin}/locale", "--version"
  end
end
