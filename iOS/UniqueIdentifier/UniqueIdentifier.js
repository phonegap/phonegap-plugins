//
//  UniqueIdentifier.js
//  UniqueIdentifierPlugin
//
//  Created by Andrew Thorp on 4/13/12
//
//
// THIS SOFTWARE IS PROVIDED BY THE ANDREW THORP "AS IS" AND ANY EXPRESS OR
// IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED WARRANTIES OF
// MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE DISCLAIMED. IN NO
// EVENT SHALL ANDREW TRICE OR CONTRIBUTORS BE LIABLE FOR ANY DIRECT,
// INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING,
// BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES; LOSS OF USE,
// DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY OF
// LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT (INCLUDING NEGLIGENCE
// OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS SOFTWARE, EVEN IF
// ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
//

var UniqueIdentifier = function(){

}

/**
 * Generate new UUID
 */
UniqueIdentifier.prototype.generateUUID = function(success, fail){
  Cordova.exec(success, fail, "UniqueIdentifier", "generateUUID", []);
};

/**
 * Return UUID stored in NSDefaults
 */
UniqueIdentifier.prototype.getUUID = function(success, fail){
  Cordova.exec(success, fail, "UniqueIdentifier", "getUUID", []);
};

Cordova.addConstructor(function(){
  if (!window.plugins){
    window.plugins = {};
  }

  window.plugins.uniqueIdentifier = new UniqueIdentifier();
});
