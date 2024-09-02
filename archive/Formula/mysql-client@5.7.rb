class MysqlClientAT57 < Formula
  desc "Open source relational database management system"
  homepage "https://dev.mysql.com/doc/refman/5.7/en/"
  url "https://cdn.mysql.com/archives/mysql-5.7/mysql-boost-5.7.34.tar.gz"
  sha256 "5bc2c7c0bb944b5bb219480dde3c1caeb049e7351b5bba94c3b00ac207929c7b"

  bottle do
    root_url "https://github.com/gromgit/homebrew-core-aarch64_linux/releases/download/mysql-client@5.7"
    sha256 aarch64_linux: "00800eb866a0a01c1f6b4c8c0cbb6ed636afb7e83fc6b16b0e3328987c338b8a"
  end

  keg_only :versioned_formula

  depends_on "cmake" => :build

  depends_on "openssl@1.1"

  uses_from_macos "libedit"

  def install
    # https://bugs.mysql.com/bug.php?id=87348
    # Fixes: "ADD_SUBDIRECTORY given source
    # 'storage/ndb' which is not an existing"
    inreplace "CMakeLists.txt", "ADD_SUBDIRECTORY(storage/ndb)", ""

    # -DINSTALL_* are relative to `CMAKE_INSTALL_PREFIX` (`prefix`)
    args = %W[
      -DCOMPILATION_COMMENT=Homebrew
      -DDEFAULT_CHARSET=utf8
      -DDEFAULT_COLLATION=utf8_general_ci
      -DINSTALL_DOCDIR=share/doc/#{name}
      -DINSTALL_INCLUDEDIR=include/mysql
      -DINSTALL_INFODIR=share/info
      -DINSTALL_MANDIR=share/man
      -DINSTALL_MYSQLSHAREDIR=share/mysql
      -DWITH_BOOST=boost
      -DWITH_EDITLINE=system
      -DWITH_SSL=yes
      -DWITH_UNIT_TESTS=OFF
      -DWITHOUT_SERVER=ON
    ]

    system "cmake", ".", *std_cmake_args, *args
    system "make", "install"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/mysql --version")
  end
end
