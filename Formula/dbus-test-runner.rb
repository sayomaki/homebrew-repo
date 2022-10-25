class DbusTestRunner < Formula
  desc "Small little utility to run executables under a new DBus session for testing"
  homepage "https://launchpad.net/dbus-test-runner"
  url "https://launchpad.net/dbus-test-runner/19.04/19.04.0/+download/dbus-test-runner-19.04.0.tar.gz"
  sha256 "645a32fbd909baf2c01438f0cbda29dc9cd01a7aba5504c45610d88e8a57cb76"
  license "GPL-3.0-only"

  bottle do
    root_url "https://github.com/willi123yao/homebrew-repo/releases/download/dbus-test-runner-19.04.0"
    sha256 monterey:     "13642fc792b9f8b80d3d4fbec0d9cc921b3df3844e445cd4eb9fdd1a187d4c54"
    sha256 big_sur:      "527fdb8d0ad3aaf6e02a83613465ee81fb2b4940c7ada1d4e325edf8232b7042"
    sha256 catalina:     "d4a7bce8cd1d2ad9315c8821cbc6c72d3f48840b40c1dded70b93c3e7b710b7d"
    sha256 x86_64_linux: "a82f7d2ed2c5352df20151f4dea62942bbb9caa888537634fe4577af17704d06"
  end

  depends_on "gobject-introspection" => :build
  depends_on "intltool" => :build
  depends_on "dbus-glib"
  depends_on "gettext"
  depends_on "glib"

  def install
    system "./configure", "--prefix=#{prefix}"
    system "make", "install"
  end

  test do
    assert_equal which("dbus-test-runner"), HOMEBREW_PREFIX/"bin/dbus-test-runner"
    assert_match "dbus-test-runner", shell_output("#{bin}/dbus-test-runner -h")
  end
end
