class PerconaXtrabackup < Formula
  desc "Open source hot backup tool for InnoDB and XtraDB databases"
  homepage "https://www.percona.com/software/mysql-database/percona-xtrabackup"
  url "https://downloads.percona.com/downloads/Percona-XtraBackup-LATEST/Percona-XtraBackup-8.0.28-20/source/tarball/percona-xtrabackup-8.0.28-20.tar.gz"
  sha256 "bfcdd838d19daa98ae8d7ddf7f84ffc89597c67edc9cc50d342f03fcca361616"

  livecheck do
    url "https://www.percona.com/downloads/Percona-XtraBackup-LATEST/"
    regex(/value=.*?Percona-XtraBackup[._-]v?(\d+(?:\.\d+)+-\d+)["' >]/i)
  end

  bottle do
    sha256 arm64_monterey: "adfd6d7b789db4e0de7974ce757159ea3c27c26f87201bee38db70c275615165"
    sha256 arm64_big_sur:  "91b6f0227d3b516723df2b231638c799fc2e43edad53a43c62624d340ffb6658"
    sha256 monterey:       "965a581de545270b0d2c7bfeee20b1fc0d1f03db8ab113339004cdfe890b2186"
    sha256 big_sur:        "3a568f94a042e9bf3ce6505968b0c04bc85b6fdc5c802a324e2b9282082d0d77"
    sha256 catalina:       "54735177095d07b3eec711b7ba23e410ffb8b2f374392c1de69751a32fc6b36f"
    sha256 x86_64_linux:   "97d549def9bfeaaa0426ef619f657db902dc7d23f595ccad9c7824302851596e"
  end

  depends_on "cmake" => :build
  depends_on "pkg-config" => :build
  depends_on "sphinx-doc" => :build
  depends_on "icu4c"
  depends_on "libev"
  depends_on "libevent"
  depends_on "libfido2"
  depends_on "libgcrypt"
  depends_on "lz4"
  depends_on "mysql-client"
  depends_on "openssl@1.1"
  depends_on "protobuf"
  depends_on "zstd"

  uses_from_macos "vim" => :build # needed for xxd
  uses_from_macos "curl"
  uses_from_macos "cyrus-sasl"
  uses_from_macos "libedit"
  uses_from_macos "perl"
  uses_from_macos "zlib"

  on_linux do
    depends_on "patchelf" => :build
    depends_on "gcc" # Requires GCC 7.1 or later
    depends_on "libaio"
  end

  fails_with :gcc do
    version "6"
    cause "The build requires GCC 7.1 or later."
  end

  # Should be installed before DBD::mysql
  resource "Devel::CheckLib" do
    url "https://cpan.metacpan.org/authors/id/M/MA/MATTN/Devel-CheckLib-1.14.tar.gz"
    sha256 "f21c5e299ad3ce0fdc0cb0f41378dca85a70e8d6c9a7599f0e56a957200ec294"
  end

  # This is not part of the system Perl on Linux and on macOS since Mojave
  resource "DBI" do
    url "https://cpan.metacpan.org/authors/id/T/TI/TIMB/DBI-1.643.tar.gz"
    sha256 "8a2b993db560a2c373c174ee976a51027dd780ec766ae17620c20393d2e836fa"
  end

  resource "DBD::mysql" do
    url "https://cpan.metacpan.org/authors/id/D/DV/DVEEDEN/DBD-mysql-4.050.tar.gz"
    sha256 "4f48541ff15a0a7405f76adc10f81627c33996fbf56c95c26c094444c0928d78"
  end

  # https://github.com/percona/percona-xtrabackup/blob/percona-xtrabackup-#{version}/cmake/boost.cmake
  resource "boost" do
    url "https://boostorg.jfrog.io/artifactory/main/release/1.73.0/source/boost_1_73_0.tar.bz2"
    sha256 "4eb3b8d442b426dc35346235c8733b5ae35ba431690e38c6a8263dce9fcbb402"
  end

  # Fix CMake install error with manpages.
  # https://github.com/percona/percona-xtrabackup/pull/1266
  patch do
    url "https://github.com/percona/percona-xtrabackup/commit/1d733eade782dd9fdf8ef66b9e9cb9e00f572606.patch?full_index=1"
    sha256 "9b38305b4e4bae23b085b3ef9cb406451fa3cc14963524e95fc1e6cbf761c7cf"
  end

  # Fix libfibo2 finding; fix unneeded coping of openssl@1.1 libs
  # Remove in the next version (8.0.29)
  patch do
    url "https://github.com/mysql/mysql-server/commit/4498aef6d4a1fd266cdbddcce60965e3cb12fe1a.patch?full_index=1"
    sha256 "09246d7f3a141adfc616bafb83f927648865eeb613f0726514fcb0aa6815d98b"
  end

  def install
    # Disable ABI checking
    inreplace "cmake/abi_check.cmake", "RUN_ABI_CHECK 1", "RUN_ABI_CHECK 0" if OS.linux?

    cmake_args = %W[
      -DBUILD_CONFIG=xtrabackup_release
      -DCOMPILATION_COMMENT=Homebrew
      -DINSTALL_PLUGINDIR=lib/percona-xtrabackup/plugin
      -DINSTALL_MANDIR=share/man
      -DWITH_MAN_PAGES=ON
      -DINSTALL_MYSQLTESTDIR=
      -DWITH_SYSTEM_LIBS=ON
      -DWITH_EDITLINE=system
      -DWITH_FIDO=system
      -DWITH_ICU=system
      -DWITH_LIBEVENT=system
      -DWITH_LZ4=system
      -DWITH_PROTOBUF=system
      -DWITH_SSL=system
      -DOPENSSL_ROOT_DIR=#{Formula["openssl@1.1"].opt_prefix}
      -DWITH_ZLIB=system
      -DWITH_ZSTD=system
    ]

    (buildpath/"boost").install resource("boost")
    cmake_args << "-DWITH_BOOST=#{buildpath}/boost"

    cmake_args.concat std_cmake_args

    # Remove conflicting manpages
    rm (Dir["man/*"] - ["man/CMakeLists.txt"])

    mkdir "build" do
      system "cmake", "..", *cmake_args
      system "make"
      system "make", "install"
    end

    # remove conflicting library that is already installed by mysql
    rm lib/"libmysqlservices.a"

    ENV.prepend_create_path "PERL5LIB", buildpath/"build_deps/lib/perl5"

    resource("Devel::CheckLib").stage do
      system "perl", "Makefile.PL", "INSTALL_BASE=#{buildpath}/build_deps"
      system "make", "install"
    end

    ENV.prepend_create_path "PERL5LIB", libexec/"lib/perl5"

    # This is not part of the system Perl on Linux and on macOS since Mojave
    if OS.linux? || MacOS.version >= :mojave
      resource("DBI").stage do
        system "perl", "Makefile.PL", "INSTALL_BASE=#{libexec}"
        system "make", "install"
      end
    end

    resource("DBD::mysql").stage do
      system "perl", "Makefile.PL", "INSTALL_BASE=#{libexec}"
      system "make", "install"
    end

    bin.env_script_all_files(libexec/"bin", PERL5LIB: libexec/"lib/perl5")
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/xtrabackup --version 2>&1")

    mkdir "backup"
    output = shell_output("#{bin}/xtrabackup --target-dir=backup --backup 2>&1", 1)
    assert_match "Failed to connect to MySQL server", output
  end
end
