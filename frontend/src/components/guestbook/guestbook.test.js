import React from 'react';
import {shallow, mount} from 'enzyme';

import Guestbook from './guestbook';

describe('Guestbook', () => {
  const shallowGuestbook = props => shallow(<Guestbook {...props}/>);
  const mountGuestbook = props => mount(<Guestbook {...props}/>);

  it('should create component', () => {
    mountGuestbook().should.have.type(Guestbook);
  });

  it('should wrap children with div', () => {
    shallowGuestbook().should.have.tagName('div');
  });

//  it('should use passed className', () => {
//    shallowGuestbook({
//      className: 'test-class'
//    }).should.have.className('test-class');
//  });

  // TODO Add more tests

// ##roboDevelopersTokenStart
  it('failing test 597', () => {
    shallowGuestbook().should.have.tagName('wat');
  });

  it('failing test 25423', () => {
    shallowGuestbook().should.have.tagName('wat');
  });

// ##roboDevelopersTokenEnd
});
